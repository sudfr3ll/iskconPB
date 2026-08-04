import { Injectable } from '@angular/core';
import { CollectionReference, DocumentData, Firestore, getDoc, updateDoc } from '@angular/fire/firestore';
import { collection, doc } from '@firebase/firestore';
import { MatSnackBar } from '@angular/material/snack-bar';
import { SharedService } from './shared.service';

@Injectable({
  providedIn: 'root'
})
export class SettingsService {

  private settingsCollection: CollectionReference<DocumentData>;

  constructor(
    private firestore: Firestore,
    private sharedService: SharedService,
    private snackbar: MatSnackBar,
  ) { 
    this.settingsCollection = collection(this.firestore, "Settings");
  }

  async getSocialMediaData() {
    const socialRef = doc(this.settingsCollection, "socialMedia");   
    const socialObjs = await getDoc(socialRef); 
    const socialData = socialObjs.data();

    return socialData;
  }

  async getContactUsData() {
    const contactRef = doc(this.settingsCollection, "contactUs");
    const contactObjs = await getDoc(contactRef);
    const contactData = contactObjs.data();

    return contactData;
  }

  async updateSocialMediaData(data: any) {
     
    const socialRef = doc(this.settingsCollection, "socialMedia");
    await updateDoc(socialRef, data);
    return true;
  }

  async updateContactUsData(data: any) {
     
    const contactRef = doc(this.settingsCollection, "contactUs");
    await updateDoc(contactRef, data);
    return true;
  }
}
