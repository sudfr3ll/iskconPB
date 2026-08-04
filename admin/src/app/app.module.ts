// import { NGXLoadingModule } from 'ngx-angular-loading';
// import { NgxSpinnerModule } from 'ngx-spinner';
import { NgModule, CUSTOM_ELEMENTS_SCHEMA } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { initializeApp,provideFirebaseApp } from '@angular/fire/app';
import { environment } from '../environments/environment';
import { provideAuth,getAuth } from '@angular/fire/auth';

import { provideFirestore,getFirestore } from '@angular/fire/firestore';
import { provideStorage,getStorage } from '@angular/fire/storage';
import { MatSidenavModule } from '@angular/material/sidenav';
import { NgMaterialMultilevelMenuModule, MultilevelMenuService } from 'ng-material-multilevel-menu';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { SidemenuComponent } from './shared/components/sidemenu/sidemenu.component';
import { MatToolbarModule } from '@angular/material/toolbar';
import { HeaderComponent } from './shared/components/header/header.component';
import { MatIconModule } from '@angular/material/icon';
import { LiveDarshanComponent } from './roles/admin/live-darshan/live-darshan.component';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material/input';
import { MatCheckboxModule } from '@angular/material/checkbox';
import { MessageComponent } from './roles/admin/message/message.component';
import { EventsComponent } from './roles/admin/events/events.component';
import { QuotesComponent } from './roles/admin/quotes/quotes.component';
import { SocialMediaComponent } from './roles/admin/settings/social-media/social-media.component';
import { ContactUsComponent } from './roles/admin/settings/contact-us/contact-us.component';
import { EditMessageComponent } from './roles/admin/dialogs/edit-message/edit-message.component';
import { MatDialogModule } from '@angular/material/dialog';
import { EditEventComponent } from './roles/admin/dialogs/edit-event/edit-event.component';
import { EditQuoteComponent } from './roles/admin/dialogs/edit-quote/edit-quote.component';
import { PicturesComponent } from './roles/admin/pictures/pictures.component';
import { EditPicturesComponent } from './roles/admin/dialogs/edit-pictures/edit-pictures.component';
import {MatSelectModule} from '@angular/material/select';
import {MatSlideToggleModule} from '@angular/material/slide-toggle';
import { Level1Component } from './roles/admin/category/level1/level1.component';
import { Level2Component } from './roles/admin/category/level2/level2.component';
import { Level3Component } from './roles/admin/category/level3/level3.component';
import { EditLevel1Component } from './roles/admin/dialogs/edit-level1/edit-level1.component';
import { EditLevel2Component } from './roles/admin/dialogs/edit-level2/edit-level2.component';
import { EditLevel3Component } from './roles/admin/dialogs/edit-level3/edit-level3.component';
import { EnquiriesComponent } from './roles/admin/enquiries/enquiries.component';
import { AudiosComponent } from './roles/admin/audios/audios.component';
import { EditAudioComponent } from './roles/admin/dialogs/edit-audio/edit-audio.component';
import { VideosComponent } from './roles/admin/videos/videos.component';
import { EditVideoComponent } from './roles/admin/dialogs/edit-video/edit-video.component';
import { ViewEnquiryComponent } from './roles/admin/dialogs/view-enquiry/view-enquiry.component';
import { FestivalsComponent } from './roles/admin/festivals/festivals.component';
import { EditFestivalComponent } from './roles/admin/dialogs/edit-festival/edit-festival.component';
import { NewsComponent } from './roles/admin/news/news.component';
import { EditNewsComponent } from './roles/admin/dialogs/edit-news/edit-news.component';
import { MatSnackBarModule } from '@angular/material/snack-bar';
import { SpinnersAngularModule } from 'spinners-angular';
import { EditDonationTypesComponent } from './roles/admin/dialogs/edit-donation-types/edit-donation-types.component';
import { DonationTypesComponent } from './roles/admin/donation-types/donation-types.component';
import { AuthComponent } from './auth/auth.component';
import { DeleteConfirmationModalComponent } from './delete-confirmation-modal/delete-confirmation-modal.component';
import { EditBlogsComponent } from './roles/admin/dialogs/edit-blogs/edit-blogs.component';
import { BlogsComponent } from './roles/admin/blogs/blogs.component';
import { MatDatepickerModule } from '@angular/material/datepicker'; 
import { MatNativeDateModule } from '@angular/material/core';
import { HomepageSettingComponent } from './roles/admin/homepage-setting/homepage-setting.component';
import { AddSectionComponent } from './roles/admin/dialogs/add-section/add-section.component';
import { EditSectionComponent } from './roles/admin/dialogs/edit-section/edit-section.component'; 
import { MatRadioModule } from '@angular/material/radio';
import { InfiniteScrollModule } from 'ngx-infinite-scroll';
import { MatChipsModule } from '@angular/material/chips';
import { SubscriptionsComponent } from './roles/admin/subscriptions/subscriptions/subscriptions.component';
import { SubscriptionTypesComponent } from './roles/admin/subscriptions/subscription-types/subscription-types.component';
import { EditSubsriptionTypesComponent } from './roles/admin/subscriptions/subscription-types/edit-subsription-types/edit-subsription-types.component';
import { ViewSubscriptionsComponent } from './roles/admin/subscriptions/subscriptions/view-subscriptions/view-subscriptions.component';
import { DatePipe } from '@angular/common';
import { DonationsComponent } from './roles/admin/donations/donations.component';
import { ViewDonationsComponent } from './roles/admin/donations/view-donations/view-donations.component';
// import { LevelOneComponent } from './roles/admin/category/level-one/level-one.component';
// import { provideAuth, getAuth } from '@angular/fire/auth';
// import { MatInputModule } from '@angular/material/input'; 

// import { NgxSpinnerModule } from 'ngx-spinner';
// import NGXLoadingModule


@NgModule({
  declarations: [
    AppComponent,
    SidemenuComponent,
    HeaderComponent,
    LiveDarshanComponent,
    MessageComponent,
    EventsComponent,
    QuotesComponent,
    SocialMediaComponent,
    ContactUsComponent,
    EditMessageComponent,
    EditEventComponent,
    EditQuoteComponent,
    PicturesComponent,
    EditPicturesComponent,
    Level1Component,
    Level2Component,
    Level3Component,
    EditLevel1Component,
    EditLevel2Component,
    EditLevel3Component,
    EnquiriesComponent,
    AudiosComponent,
    EditAudioComponent,
    VideosComponent,
    EditVideoComponent,
    ViewEnquiryComponent,
    FestivalsComponent,
    EditFestivalComponent,
    NewsComponent,
    EditNewsComponent,
    EditDonationTypesComponent,
    DonationTypesComponent,
    AuthComponent,
    DeleteConfirmationModalComponent,
    EditBlogsComponent,
    BlogsComponent,
    HomepageSettingComponent,
    AddSectionComponent,
    EditSectionComponent,
    SubscriptionsComponent,
    SubscriptionTypesComponent,
    EditSubsriptionTypesComponent,
    ViewSubscriptionsComponent,
    DonationsComponent,
    ViewDonationsComponent,
    // LevelOneComponent
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    MatSidenavModule,
    NgMaterialMultilevelMenuModule,
    MatToolbarModule,
    MatIconModule,
    FormsModule,
    
    ReactiveFormsModule,
    MatFormFieldModule,
    MatInputModule,
    MatDialogModule,
    MatSelectModule,
    MatSlideToggleModule,
    MatSnackBarModule,
    MatCheckboxModule,
    SpinnersAngularModule,
    MatDatepickerModule,
    MatNativeDateModule,
    MatRadioModule,
    InfiniteScrollModule,
    // NGXLoadingModule,
    provideFirebaseApp(() => initializeApp(environment.firebase)),
    provideAuth(() => getAuth()),
    provideFirestore(() => getFirestore()),
    provideStorage(() => getStorage()),
    BrowserAnimationsModule,
    MatChipsModule
  ],
  schemas: [CUSTOM_ELEMENTS_SCHEMA],
  providers: [MultilevelMenuService, DatePipe],
  bootstrap: [AppComponent]
})
export class AppModule { }
