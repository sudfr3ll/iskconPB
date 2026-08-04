import { Injectable } from '@angular/core';
import { ApplicationVerifier, Auth, ConfirmationResult, onAuthStateChanged, PhoneAuthProvider, RecaptchaVerifier, signInWithCredential, signInWithPhoneNumber, signOut } from '@angular/fire/auth';
import { Router } from '@angular/router';
import { BehaviorSubject } from 'rxjs';
import { ProfileService } from './profile.service';

@Injectable({
  providedIn: 'root'
})
export class AuthService {

  private loggedIn$ = new BehaviorSubject<boolean>(false);
  role$ = new BehaviorSubject<string>('user');
  userId: any = '';
  confirmationResult: ConfirmationResult | undefined;
  recaptchaVerifier: ApplicationVerifier | undefined;
  phoneNo = "";

  constructor(
    private auth: Auth,
    private router: Router,
    private profileService: ProfileService
  ) { }

  autoLogin() {
    onAuthStateChanged(this.auth, async user => {
      if(!user) return;
      await this.setUserId(user.uid);
      await this.setUserPhone(user.phoneNumber);
      const doc: any = await this.profileService.getUserData();
      const role = doc?.role || 'admin';
      this.role$.next(role);
      await this.setUserRole(role);
      this.loggedIn$.next(true);
      this.handleRoleState(role, doc);
    });
  }

  async getUserIdFromStorage() {
    return localStorage.getItem("userId");
  }

  getUserId() {
    return this.userId;
  }

  async setUserId(userId: string) {
    this.userId = userId;
    await localStorage.setItem("userId",userId);
  }

  async setUserPhone(phoneNo: any) {
    this.phoneNo = phoneNo;
    await localStorage.setItem("phoneNo",phoneNo);
  }

  async setUserRole(role: string) {
    await localStorage.setItem("userRole",role);
  }

  async sendOtp(phone: string, recaptchaVerifier: RecaptchaVerifier) {
    return new Promise((resolve, reject) => {
      try {
        signInWithPhoneNumber(this.auth, phone, recaptchaVerifier)
          .then(async (confirmationResponse) => {
            this.confirmationResult = confirmationResponse;
            resolve(true);
          })
          .catch(async (err) => {
            this.confirmationResult = undefined;
            resolve(false);
          });
      } catch (err) {
        resolve(false);
      }
    })
  }

  async verifyOtp(otp: string) {
    return new Promise((resolve, reject) => {
      try {
        var credential = PhoneAuthProvider.credential(this.confirmationResult!.verificationId, otp)
        signInWithCredential(this.auth, credential)
          .then((result) => {
            // this.setUserId(result.user.uid);
            // this.router.navigate(['/categories']);
            resolve(true);
          })
          .catch((err: any) => {
            resolve(false);
          });
      } catch (err) {
        resolve(false);
        console.log('err', err);
      }
    })
  }

  public isLoggedIn() {
    return this.loggedIn$.asObservable();
  }

  logout() {
    signOut(this.auth).then(() => {
      localStorage.clear();
      this.router.navigate(['']);
      this.loggedIn$.next(false);
    }).catch((error) => {
    });
  }

  handleRoleState(role: string, doc?:any) {
    switch (role) {
      case 'admin':
        this.router.navigate(['homepage-setting']);
        break;

    }
  }
}
