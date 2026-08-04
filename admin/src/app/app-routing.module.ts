import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { EventsComponent } from './roles/admin/events/events.component';
import { LiveDarshanComponent } from './roles/admin/live-darshan/live-darshan.component';
import { MessageComponent } from './roles/admin/message/message.component';
import { QuotesComponent } from './roles/admin/quotes/quotes.component';
import { ContactUsComponent } from './roles/admin/settings/contact-us/contact-us.component';
import { SocialMediaComponent } from './roles/admin/settings/social-media/social-media.component';
import { PicturesComponent } from './roles/admin/pictures/pictures.component';
import { Level1Component } from './roles/admin/category/level1/level1.component';
import { Level2Component } from './roles/admin/category/level2/level2.component';
import { Level3Component } from './roles/admin/category/level3/level3.component';
import { EnquiriesComponent } from './roles/admin/enquiries/enquiries.component';
import { AudiosComponent } from './roles/admin/audios/audios.component';
import { VideosComponent } from './roles/admin/videos/videos.component';
import { AuthComponent } from './auth/auth.component';
import { FestivalsComponent } from './roles/admin/festivals/festivals.component';
import { NewsComponent } from './roles/admin/news/news.component';
import { DonationTypesComponent } from './roles/admin/donation-types/donation-types.component';
import { BlogsComponent } from './roles/admin/blogs/blogs.component';
import { HomepageSettingComponent } from './roles/admin/homepage-setting/homepage-setting.component';
import { SubscriptionsComponent } from './roles/admin/subscriptions/subscriptions/subscriptions.component';
import { SubscriptionTypesComponent } from './roles/admin/subscriptions/subscription-types/subscription-types.component';
import { DonationsComponent } from './roles/admin/donations/donations.component';

const routes: Routes = [
  {
    path: '',
    component: AuthComponent
  },
  {
    path: 'homepage-setting',
    component: HomepageSettingComponent
  },
  {
    path: 'live-darshan',
    component: LiveDarshanComponent
  },
  {
    path: 'message',
    component: MessageComponent
  },
  {
    path: 'events',
    component: EventsComponent
  },
  {
    path: 'quotes',
    component: QuotesComponent
  },
  {
    path: 'social-media',
    component: SocialMediaComponent
  },
  {
    path: 'contact-us',
    component: ContactUsComponent
  },
  {
    path:'pictures',
    component:PicturesComponent
  },
  {
    path:'level-1',
    component:Level1Component
  },
  {
    path:'level-2',
    component:Level2Component
  },
  {
    path:'level-3',
    component:Level3Component
  },
  {
    path:'enquiries',
    component: EnquiriesComponent
  },
  {
    path:'donations',
    component: DonationsComponent
  },
  {
    path:'audios',
    component : AudiosComponent
  },
  {
    path : 'videos',
    component : VideosComponent
  },
  {
    path : 'festivals',
    component : FestivalsComponent
  },
  {
    path : 'news',
    component : NewsComponent
  },
  {
    path: 'donation-types',
    component: DonationTypesComponent
  },
  {
    path: 'subscriptions',
    component: SubscriptionsComponent
  },
  {
    path: 'subscription-types',
    component: SubscriptionTypesComponent
  },
  {
    path: 'blogs',
    component: BlogsComponent
  }
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
