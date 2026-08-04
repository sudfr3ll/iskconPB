import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { PaymentPageComponent } from './payment-page/payment-page.component';
import { SubscriptionPageComponent } from './subscription-page/subscription-page.component';
import { PaytmSuccessComponent } from './paytm-success/paytm-success.component';
import { PaytmFailureComponent } from './paytm-failure/paytm-failure.component';

const routes: Routes = [
  {
    path: '',
    redirectTo: 'paymentPage',
    pathMatch: 'full'
  },
  {
    path: 'paymentPage',
    component: PaymentPageComponent
  },
  {
    path: 'subscriptionPage',
    component: SubscriptionPageComponent
  },
  {
    path: 'paytm-success',
    component: PaytmSuccessComponent
  },
  {
    path: 'paytm-failure',
    component: PaytmFailureComponent
  },
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
