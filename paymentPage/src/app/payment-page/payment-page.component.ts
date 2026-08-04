import { Component, OnInit } from '@angular/core';
import { Inject, Injectable } from '@angular/core';
import { getFunctions, httpsCallable } from "firebase/functions";
import { initializeApp } from '@firebase/app';
import { environment } from 'src/environments/environment';
import { addDoc, CollectionReference, doc, DocumentData, Firestore, getDoc, getDocs, updateDoc, deleteDoc, setDoc, collectionData, QueryConstraint, query, where, orderBy } from '@angular/fire/firestore';
import { collection, serverTimestamp } from '@firebase/firestore'; import { BehaviorSubject } from 'rxjs';
import { Router, NavigationExtras, ActivatedRoute } from '@angular/router';
import { DOCUMENT } from "@angular/common";
import { NgxUiLoaderService } from 'ngx-ui-loader';
import { CheckoutService } from 'paytm-blink-checkout-angular';

@Component({
  selector: 'app-payment-page',
  templateUrl: './payment-page.component.html',
  styleUrls: ['./payment-page.component.scss']
})
@Injectable({
  providedIn: 'root'
})
export class PaymentPageComponent implements OnInit {
  showLoader: boolean = true;
  private integrationCollection: CollectionReference<DocumentData>;
  disable_button: boolean = false;
  nameError: boolean = false;
  lastnameError: boolean = false
  phone_numberError: boolean = false
  emailError: boolean = false
  amtError: boolean = false;
  emailRegex = /[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,4}$/;
  phoneRegex = /^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$/;
  typingTimer: any;

  // disable_button: boolean = false;
  // nameError: boolean = false;
  // lastnameError: boolean = false
  // phone_numberError: boolean = false
  // emailError: boolean = false
  // emailRegex = /[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,4}$/;
  // phoneRegex = /^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$/;


  donationData: any = {
    firstName: 'dummy first name',
    lastName: 'dummy last name',
    email: 'xyz@gmail.com',
    phoneNo: '1234567890',
    amount: 0,
  }
  customAmounts = [500, 1000, 1500, 2000, 5000, 10000, 50000, 100000];
  dId: any = ''
  dType: any = ''
  functions: any;

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
    private loaderService: NgxUiLoaderService,
    private readonly checkoutService: CheckoutService,
    private router: Router
  ) {
    this.functions = getFunctions(initializeApp(environment.firebase));
    this.integrationCollection = collection(this.firestore, "Integrations");
    this.dId = this.activatedRoute.snapshot.queryParamMap.get('dId') || 'dOqzlSGfILYA08EwVLcq';
    this.dType = this.activatedRoute.snapshot.queryParamMap.get('dType') || 'Small Events';
    this.donationData.amount = this.activatedRoute.snapshot.queryParamMap.get('dAmount') || 0;
    this.mode = this.activatedRoute.snapshot.queryParamMap.get('mode') || 'ccAvenue';
    console.log('DID :', this.dId)
    console.log('DTYPE : ', this.dType)
    if (!this.dId || !this.dType) {
      alert('d-id or d-type missing!!!')
    }
  }

  ngOnInit(): void {
    // this.loaderService.start()
    this.hideZero()
    this.initDonation();
  }
  onChangeAmountSelection(event: any) {
    console.log('onChangeAmountSelection', event.target.value)
    this.donationData.amount = +event.target.value
    this.minOrderAmountAlert()
  }

  donationDataVerify() {
    // console.log('enter')
    if (this.donationData.firstName && this.donationData.lastName && this.donationData.amount && this.donationData.email && this.donationData.phoneNo && this.dId && this.dType) {
      // console.log('verified')
      return true
    } else {
      // console.log('failed')
      return false
    }
  }

  async encryptDonationData(apiBody: any) {
    try {
      const initDonation = httpsCallable(this.functions, 'payments-payURequestModulator_Encrypt');
      let modulationState = await initDonation(apiBody)
      console.log('modulationState : ', modulationState)
      return modulationState.data
    } catch (error) {
      console.log('error in encryptDonationData!!! OC : ', error)
    }
  }

  async initDonation() {
    if (this.donationData.firstName?.length < 2 || this.donationData.firstName?.length < 2 || !this.emailRegex.test(this.donationData.email) || !this.phoneRegex.test(this.donationData.phoneNo)) {
      console.log('initDonation...');
      if (this.donationData.firstName?.length < 2) {
        this.nameError = true
      } else {
        this.nameError = false
      }

      if (this.donationData.lastName?.length < 2) {
        this.lastnameError = true
      } else {
        this.lastnameError = false
      }
      if (!this.emailRegex.test(this.donationData.email)) {
        this.emailError = true
        console.log('email not correct')
      } else {
        this.emailError = false
      }
      if (this.donationData.amount < 10) {
        this.amtError = true
        // console.log('email not correct')
      } else {
        this.amtError = false
      }
      if (!this.phoneRegex.test(this.donationData.phoneNo)) {
        // console.log(this.donationData.phoneNo?.length)
        this.phone_numberError = true
      } else {
        // console.log(this.donationData.phoneNo?.length)
        this.phone_numberError = false
      }
    }
    else {
      console.log('started donation !!!')
      this.disable_button = true;
      this.phone_numberError = false
      this.nameError = false
      this.lastnameError = false
      this.emailError = false
      if (this.donationDataVerify()) {
        console.log('started donation !!!')
        console.log('started donation !!!', this.donationData)
        // let payUData: any = {}
        // const integrations = await getDocs(this.integrationCollection)
        // integrations.forEach((doc) => {
        //   if (doc.id === 'PayU') {
        //     payUData = {
        //       id: doc.id,
        //       ...doc.data()
        //     }
        //   }
        // });
        // console.log('payU : ', payUData)

        // let txnLink = payUData.pgState ? payUData.pg_links.prod : payUData.pg_links.dev

        // let apiBody = {
        //   key: payUData.credentials.merchantId,
        //   amount: parseFloat(this.donationData.amount.toString()),
        //   productinfo: this.dType,
        //   docId: this.dId,
        //   email: this.donationData.email,
        //   phone: this.donationData.phoneNo,
        //   firstname: this.donationData.firstName,
        //   lastname: this.donationData.lastName,
        //   type: 'encrypt'
        // }
        // // let decryptedData: any = await this.encryptDonationData(apiBody)
        // // console.log('decryptedData : ', decryptedData)

        // const initDonation = httpsCallable(this.functions, 'payments-generateSHA512Response');
        // // await initDonation(decryptedData.data)
        // await initDonation(apiBody)
        //   .then((response: any) => {
        //     console.log('Response : ', response.data)
        //     const form = this.document.createElement("form");
        //     form.method = "POST";
        //     form.target = "_self";
        //     form.action = txnLink;
        //     let paymentPayload: any = {
        //       key: payUData.credentials.merchantId,
        //       txnid: response.data.txnId,
        //       amount: parseFloat(response.data.data.amount),
        //       productinfo: response.data.data.productinfo,
        //       firstname: response.data.data.firstname,
        //       lastname: response.data.data.firstname,
        //       email: response.data.data.email,
        //       phone: response.data.data.phone,
        //       hash: response.data.hash,
        //       surl: response.data.redirectURL.surl,
        //       curl: response.data.redirectURL.curl,
        //       furl: response.data.redirectURL.furl,
        //     }
        //     console.log('payment payload : ', paymentPayload)
        //     for (let prop in paymentPayload) {
        //       const input = this.document.createElement("input");
        //       input.type = "hidden";
        //       input.name = prop;
        //       input.value = paymentPayload[prop];
        //       form.append(input);
        //     }
        //     this.document.body.appendChild(form);
        //     form.submit();
        //   })
        //   .catch((error) => {
        //     console.log('error : ', error)
        //   })

        this.donationData['docId'] = this.dId;
        this.donationData['productinfo'] = this.dType;

        // *** New flow for CCAvenue  

        if (this.mode === 'ccAvenue') {

          let ccAvenueData: any = {}
          const integrations = await getDocs(this.integrationCollection)
          integrations.forEach((doc) => {
            if (doc.id === 'CCAvenue') {
              ccAvenueData = {
                id: doc.id,
                ...doc.data()
              }
            }
          });
          console.log('CCAvenue : ', ccAvenueData)
          const initDonation = httpsCallable(this.functions, 'payments-processCCAvenuePayload');
          await initDonation(this.donationData)
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

        if (this.mode === 'paytm') {
          this.initializePaytmCheckout()
        }

      } else {
        alert('incomplete data received!!!')
      }
    }
  }

  hideZero() {
    if (this.donationData.amount === 0) {
      this.donationData.amount = '';
      if (this.donationData.amount == '') {
        this.amtError = false
      }
    }
    console.log('this.donationData.amount', this.donationData.amount)

    // if (this.donationData.amount > 0 && this.donationData.amount < 10) {
    //   this.amtError = true
    // } else if (this.donationData.amount > 10){
    //   this.amtError = false
    // }
  }

  minOrderAmountAlert() {
    clearTimeout(this.typingTimer);
    this.typingTimer = setTimeout(() => {
      if (this.donationData.amount > 0 && this.donationData.amount < 10 && this.donationData.amount !== '') {
        this.amtError = true
      } else if (this.donationData.amount > 10 || this.donationData.amount == '' || !this.donationData.amount) {
        this.amtError = false
      }
    }, 1000);
  }

  //paytm flow

  appendHandler(config: any, txnRes: any): any {
    const newConfig = { ...config };
    // txnToken: txnTokenRes.txnToken,
    // merchantId: paytmCred.merchantId,
    // isStaging: !paytmCred.isProduction,
    // callbackUrl: txnTokenRes.callbackUrl,
    // donationId
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
    const ref = doc(this.firestore, `donations/${this.dId}`);
    return updateDoc(ref, obj)
  }

  notifyMerchantHandler = (eventType: any, data: any): void => {
    console.log('MERCHANT NOTIFY LOG', eventType, data);
    if(eventType === 'APP_CLOSED') {
      this.router.navigate(['paytm-failure']);
    }
  }

  async initializePaytmCheckout(): Promise<void> {
    const amount = parseFloat(this.donationData.amount).toFixed(2);
    const getTxnToken = httpsCallable(this.functions, 'payments-paytm_getTxnToken');
    const response: any = await getTxnToken({ amount, docId: this.dId });
    const txnRes = { ...response.data, amount };
    console.log('txnRes', txnRes);
    const config = this.appendHandler(this.paytmConfig, txnRes);
    console.log('config', config);
    this.loaderService.stop()
    this.checkoutService.init(config, { env: 'PROD', openInPopup: true });
  }
}