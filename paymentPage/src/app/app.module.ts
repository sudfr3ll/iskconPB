import { CUSTOM_ELEMENTS_SCHEMA, NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';
import { FormsModule } from '@angular/forms';
import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { environment } from '../environments/environment';
import { initializeApp,provideFirebaseApp } from '@angular/fire/app';
import { provideFirestore,getFirestore } from '@angular/fire/firestore';
import { PaymentPageComponent } from './payment-page/payment-page.component';
import { NgxUiLoaderModule } from 'ngx-ui-loader';
import { SubscriptionPageComponent } from './subscription-page/subscription-page.component';
import { SpinnersAngularModule } from 'spinners-angular';
import { CheckoutModule } from 'paytm-blink-checkout-angular';
import { PaytmSuccessComponent } from './paytm-success/paytm-success.component';
import { PaytmFailureComponent } from './paytm-failure/paytm-failure.component';

@NgModule({
  declarations: [
    AppComponent,
    PaymentPageComponent,
    SubscriptionPageComponent,
    PaytmSuccessComponent,
    PaytmFailureComponent,
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    FormsModule,
    NgxUiLoaderModule,
    SpinnersAngularModule,
    CheckoutModule,
    provideFirebaseApp(() => initializeApp(environment.firebase)),
    provideFirestore(() => getFirestore()),
  ],
  schemas: [CUSTOM_ELEMENTS_SCHEMA],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }
