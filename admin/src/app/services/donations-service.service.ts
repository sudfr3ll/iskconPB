import { Injectable } from '@angular/core';
import { addDoc, CollectionReference, doc, DocumentData, Firestore, getDoc, getDocs, updateDoc, deleteDoc, setDoc, collectionData, QueryConstraint, query, where, orderBy } from '@angular/fire/firestore';
import { collection, serverTimestamp } from '@firebase/firestore';
import { BehaviorSubject } from 'rxjs';
import { SharedService } from './shared.service';
import { UtilityService } from './utility.service';

@Injectable({
  providedIn: 'root'
})
export class DonationsServiceService {

  donationTypes$ = new BehaviorSubject<any[]>([]);
  donations$ = new BehaviorSubject<any[]>([]);

  private donationTypesCollection: CollectionReference<DocumentData>;
  private donationsCollection: CollectionReference<DocumentData>;


  constructor(
    private firestore: Firestore,
    private utilityService: UtilityService,
    private sharedService: SharedService
  ) {
    this.donationTypesCollection = collection(this.firestore, "DonationTypes");
    this.donationsCollection = collection(this.firestore, "donations");
  }

  async getDonationTypes() {
    return new Promise(async resolve => {
      const clauses: QueryConstraint[] = [orderBy('createdAt', 'desc')]
      const q = query(this.donationTypesCollection, ...clauses);
      const observable = collectionData(q, { idField: 'id' });
      observable.subscribe(data => {
        this.donationTypes$.next(data)
        resolve(true);
      });
    })
  }

  
  // async getDonations() {
  
  //   console.log('getting donations!');
  //   const snapshot = await getDocs(this.donationsCollection);
  //   const arr: any[] = snapshot.docs.map(doc => {
  //     return { id: doc.id, ...doc.data() };
  //   });
  //   return arr.sort((a, b) => b.createdAt - a.createdAt);
  // }

  async getDonations(startDate: any, endDate: any) {
    console.log('getting donations with date range:', startDate, endDate);
    const snapshot: any = await getDocs(this.donationsCollection);
    const arr: any[] = snapshot.docs.map((doc: any) => {
      return { id: doc.id, ...doc.data() };
    });
    console.log('all donations:', arr);
    const filteredArr = arr.filter((donation: any) => {
      const createdAt = new Date(donation.createdAt.seconds * 1000 + donation.createdAt.nanoseconds / 1000000);
      return createdAt.getTime() >= startDate.getTime() && createdAt.getTime() <= endDate.getTime();
    });
    console.log('filtered donations:', filteredArr);
    return filteredArr.sort((a: any, b: any) => b.createdAt.seconds - a.createdAt.seconds);
  }
  

  async updateDonationTypes(data: any, docId: string) {

    if (!docId) {
      docId = doc(this.donationTypesCollection).id;
    }
    data.id = docId;

    if (data.coverImage.includes('data:image/jpeg;base64,') || data.coverImage.includes('data:image/jpg;base64,') || data.coverImage.includes('data:image/png;base64,') || data.coverImage.includes('data:image/gif;base64,')) {
      data.coverImage = await this.utilityService.getUrlForUploadedImage(data.coverImage, `donationTypes/${data.id}/images/image.png`)
    }
    const ref = doc(this.donationTypesCollection, data.id)
    const { id, ...updatedData } = data;

    let donationTypes = this.donationTypes$.getValue();
    const index = donationTypes.findIndex(f => f.id == data.id)
    if (index === -1) {
      donationTypes.push({ ...data, id })
    } else {
      donationTypes[index] = { ...data, id }
    }
    this.donationTypes$.next(donationTypes)
    await this.sharedService.updateDocData(ref, updatedData);

    return true;
  }

  async addDonationTypes(data: any) {
    // data.createdAt = new Date()
    const docRef = await addDoc(this.donationTypesCollection, data);
    const newDoc = await getDoc(docRef);
    return { id: newDoc.id, ...newDoc.data() }
  }

  async delete(id: string) {

    let donationTypesArr = this.donationTypes$.getValue();
    let updatedDonationTypes = await donationTypesArr.filter(f => f.id != id);
    this.donationTypes$.next(updatedDonationTypes);

    const docRef = await doc(this.donationTypesCollection, `${id}`);

    return deleteDoc(docRef);
  }
}
