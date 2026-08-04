import { Injectable } from '@angular/core';
import { Firestore } from '@angular/fire/firestore';
import { collection, CollectionReference, doc, DocumentData, getDocs } from '@firebase/firestore';

@Injectable({
  providedIn: 'root'
})
export class EnquiriesService {

  private enquiriesCollection: CollectionReference<DocumentData>;

  constructor(
    private firestore: Firestore
  ) {
    this.enquiriesCollection = collection(this.firestore, "Enquiries");
  }
  async getEnquiry() {
    
    console.log('getting quotes!')
    let arr: any = [];
    const q = await getDocs(this.enquiriesCollection)
    q.forEach((doc) => {
      arr.push({
        id: doc.id,
        ...doc.data()
      })
    });
    return arr;
  }
}