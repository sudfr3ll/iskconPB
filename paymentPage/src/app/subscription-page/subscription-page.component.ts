import { Component, OnInit } from '@angular/core';
import { Inject } from '@angular/core';
import { getFunctions, httpsCallable } from "firebase/functions";
import { initializeApp } from '@firebase/app';
import { environment } from 'src/environments/environment';
import { addDoc, CollectionReference, doc, DocumentData, Firestore, getDoc, getDocs, updateDoc, deleteDoc, setDoc, collectionData, QueryConstraint, query, where, orderBy } from '@angular/fire/firestore';
import { ActivatedRoute, Router } from '@angular/router';
import { DOCUMENT } from "@angular/common";
import { CheckoutService } from 'paytm-blink-checkout-angular';

@Component({
  selector: 'app-subscription-page',
  templateUrl: './subscription-page.component.html',
  styleUrls: ['./subscription-page.component.scss']
})
export class SubscriptionPageComponent implements OnInit {
  disable_button: boolean = false;
  functions: any;
  showLoader: boolean = true;
  amount: any;
  docId: string;

  mode = 'ccAvenue';
  paytmConfig = {
    style: {
      bodyBackgroundColor: "#fafafb",
      bodyColor: "",
      themeBackgroundColor: "#dfa231",
      themeColor: "#ffffff",
      headerBackgroundColor: "#284055",
      headerColor: "#ffffff",
      errorColor: "",
      successColor: "",
      card: {
        padding: "",
        backgroundColor: ""
      }
    },
    jsFile: "",
    data: {
      orderId: "",
      amount: "",
      token: "",
      tokenType: "TXN_TOKEN",
      userDetail: {
        mobileNumber: "",
        name: ""
      }
    },
    merchant: {
      mid: "",
      name: "Iskon Punjabi Bagh",
      logo: "",
      redirect: false
    },
    mapClientMessage: {},
    labels: {},
    payMode: {
      labels: {},
      filter: {
        exclude: []
      },
      order: [
        "NB",
        "CARD",
        "LOGIN"
      ]
    },
    flow: "DEFAULT"
  };

  constructor(
    private firestore: Firestore,
    private activatedRoute: ActivatedRoute,
    @Inject(DOCUMENT)
    private document: Document,
    private readonly checkoutService: CheckoutService,
    private router: Router
  ) {
    this.functions = getFunctions(initializeApp(environment.firebase));
    this.amount = this.activatedRoute.snapshot.queryParamMap.get('amount') || '0';
    this.docId = this.activatedRoute.snapshot.queryParamMap.get('docId') || 'xyz';
    this.mode = this.activatedRoute.snapshot.queryParamMap.get('mode') || 'ccAvenue';
    if (!this.amount) {
      alert('Amount is missing !!!')
    }
  }
  ngOnInit(): void {
    this.initDonation();
  }

  donationDataVerify() {
    return this.amount ? true : false;
  }

  async initDonation() {
    console.log('started donation !!!')
    this.disable_button = true;
    if (this.donationDataVerify()) {
      let paymentData = {
        type: 'subscriptionOneTime',
        amount: this.amount,
        docId: this.docId
      }

      if (this.mode === 'ccAvenue') {
        console.log('started donation !!!', paymentData)
        const initDonation = httpsCallable(this.functions, 'payments-processCCAvenuePayload');
        await initDonation(paymentData)
          .then(response => {
            let checkoutResponse: any = response.data
            console.log('Response received : ', checkoutResponse)
            if (checkoutResponse.status) {
              console.log('Success ! ')
              let paymentPayload: any = {
                encRequest: checkoutResponse.encryptedData,
                access_code: checkoutResponse.accessCode
              }
              const form = this.document.createElement("form");
              form.method = "POST";
              form.target = "_self";
              form.action = "https://secure.ccavenue.com/transaction/transaction.do?command=initiateTransaction";
              for (let prop in paymentPayload) {
                const input = this.document.createElement("input");
                input.type = "hidden";
                input.name = prop;
                input.value = paymentPayload[prop];
                form.append(input);
              }
              this.document.body.appendChild(form);
              form.submit();
            } else {
              console.log('Error in processCCAvenuePayload !', checkoutResponse)
            }
          })
          .catch(error => {
            console.log('Error in processCCAvenuePayload : ', error)
          })
        // this.disable_button = false;
      }

      if(this.mode === 'paytm') {
        this.initializePaytmCheckout()
      }
    } else {
      alert('Incorrect subscription amount!!!')
    }
  }

  //paytm flow

  appendHandler(config: any, txnRes: any): any {
    const newConfig = { ...config };
    newConfig.data.orderId = txnRes.donationId;
    newConfig.data.amount = txnRes.amount;
    newConfig.data.token = txnRes.txnToken;
    newConfig.merchant.mid = txnRes.merchantId;
    newConfig.handler = {
      notifyMerchant: this.notifyMerchantHandler,
      transactionStatus: (data: any) => { this.transactionStatusHandler(data) }
    }

    return newConfig;
  }

  async transactionStatusHandler(data: any) {
    console.log('data', data);
    if (data["STATUS"] == 'TXN_SUCCESS') {
      console.log('txn success', data);
      await this.updatePaymentStatus({
        'payment.status': 'completed',
        'payment.mode': 'paytm',
        'payment.details': data
      });
      this.router.navigate(['paytm-success']);
    }
    if (data["STATUS"] == 'TXN_FAILURE') {
      console.log('txn success', data);
      await this.updatePaymentStatus({
        'payment.status': 'failed',
        'payment.mode': 'paytm',
        'payment.details': data
      });
      this.router.navigate(['paytm-failure']);
    }
  }

  async updatePaymentStatus(obj: any) {
    const ref = doc(this.firestore, `subscriptions/${this.docId}`);
    return updateDoc(ref, obj)
  }

  notifyMerchantHandler = (eventType: any, data: any): void => {
    console.log('MERCHANT NOTIFY LOG', eventType, data);
    if(eventType === 'APP_CLOSED') {
      this.router.navigate(['paytm-failure']);
    }
  }

  async initializePaytmCheckout(): Promise<void> {
    const amount = parseFloat(this.amount).toFixed(2);
    const getTxnToken = httpsCallable(this.functions, 'payments-paytm_getTxnToken');
    const response: any = await getTxnToken({ amount, docId: this.docId });
    const txnRes = { ...response.data, amount };
    console.log('txnRes', txnRes);
    const config = this.appendHandler(this.paytmConfig, txnRes);
    console.log('config', config);
    this.checkoutService.init(config, { env: 'PROD', openInPopup: true });
  }
}
