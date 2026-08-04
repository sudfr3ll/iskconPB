import { Component, OnInit } from '@angular/core';
import { Auth, RecaptchaVerifier } from '@angular/fire/auth';
import { AuthService } from '../services/auth.service';
import { UtilityService } from '../services/utility.service';

@Component({
  selector: 'app-auth',
  templateUrl: './auth.component.html',
  styleUrls: ['./auth.component.scss']
})
export class AuthComponent implements OnInit {

  phone = "";
  otp = "";
  signInFlag = true;
  isSendingOtp = false;

  recaptchaVerifier: any;
  confirmationResult: any;
  isVerifyingOtp = false;

  constructor(
    private auth: Auth,
    private authService: AuthService,
    private utilityService: UtilityService,
  ) { }

  ngOnInit(): void {
    // Turn off phone auth app verification.
    this.auth.settings.appVerificationDisabledForTesting = false;
    this.recaptchaVerifier = new RecaptchaVerifier(
      'recaptcha-container',
      {
        size: 'invisible',
        callback: async (response: any) => {
          console.log('reCAPTCHA solved', response);
          await this.sendOtp();
        },
        'expired-callback': async (res: any) => {
          console.log('ex-res', res);
        },
      },
      this.auth);
  }

  async sendOtp() {
    if(this.phone){
      try {
        let phone = this.phone.includes('+') ? this.phone : '+91' + this.phone;
        if(this.phone){
          this.isSendingOtp = true;
          const isSendPhone = await this.authService.sendOtp(phone, this.recaptchaVerifier);
          console.log(isSendPhone);
          if(!isSendPhone){
            // this.utilityService.presentAlert('Please enter Valid phone number.');
            this.isSendingOtp = false;
          }else{
            this.signInFlag = false;
            this.isSendingOtp = false
          }
        
        }  
      } catch (err) {
        console.log('otp-error : ', err);
        // this.utilityService.presentAlert('There is some issue in sending OTP. Please try again later.');
        this.signInFlag = true;
      }
      // else this.utilityService.presentAlert('Please enter phone number.');
    }
  }

  async verifyOtp() {
    this.isVerifyingOtp = true;
    const res = await this.authService.verifyOtp(this.otp);
    if(!res) {
      this.isVerifyingOtp = false;
      // this.utilityService.presentAlert('OTP did not match. Please check your OTP.');
    }
  }

}