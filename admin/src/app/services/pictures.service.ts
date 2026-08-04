import { Injectable } from '@angular/core';
import { addDoc, CollectionReference, doc, DocumentData, Firestore, getDoc, getDocs, updateDoc, deleteDoc, setDoc, collectionData, QueryConstraint, query, where, orderBy, limit, startAfter, collectionGroup } from '@angular/fire/firestore';
import { collection, serverTimestamp } from '@firebase/firestore';
import { BehaviorSubject } from 'rxjs';
import { SharedService } from './shared.service';
import { UtilityService } from './utility.service';

@Injectable({
  providedIn: 'root'
})
export class PicturesService {
  pictures$ = new BehaviorSubject<any[]>([]);
  array: any[] = []
  lastArrayDoc: any;

  private picturesCollection: CollectionReference<DocumentData>;

  constructor(
    private firestore: Firestore,
    private utilityService: UtilityService,
    private sharedService: SharedService
  ) {
    this.picturesCollection = collection(this.firestore, "Pictures");

  }

  // async getPicture() {
  //      return new Promise(async resolve => {
  //   console.log('getting pictures');
  //   const clauses: QueryConstraint[] = [orderBy('createdAt', 'desc')]
  //   const q = query(this.picturesCollection, ...clauses);
  //   const observable = collectionData(q, { idField: 'id' });
  //   observable.subscribe(data => {
  //     this.pictures$.next(data)
  //     resolve(true);
  //   });
  //   });
  // }

  async getPicture() {

    return new Promise(async resolve => {
      console.log('getting pictures');
      const clauses: QueryConstraint[] = [orderBy('createdAt', 'desc')]
      const q = query(this.picturesCollection, ...clauses);
      const observable = collectionData(q, { idField: 'id' });
      observable.subscribe(data => {
        this.pictures$.next(data)
        resolve(true);
      });
    });
  
    // return new Promise(async resolve => {
    //   this.array = []
    //   console.log('getting pictures');
    //   const clauses: QueryConstraint[] = [orderBy('createdAt', 'desc')]
    //   const q = query(this.picturesCollection, ...clauses, limit(20));
    //   const snapshot = await getDocs(q);
    //   console.log('snapshot docs', snapshot.docs);

    //   if (!snapshot.docs?.length) {
    //     return {
    //       status: 'no_data', data: []
    //     }
    //   }

    //   this.lastArrayDoc = snapshot.docs[snapshot.docs.length - 1];
    //   for (const doc of snapshot.docs) {
    //     this.array.push({ ...doc.data(), id: doc.id });
    //   }

    //   const observable = collectionData(q, { idField: 'id' });
    //   observable.subscribe(data => {
    //     this.pictures$.next(data)
    //     resolve(true);
    //   });

    //   return {
    //     status: 'available', data: this.array
    //   };
    // });
   
    }     
  
  async getMorePictures() {
    // return new Promise(async resolve => {
    // const clauses: QueryConstraint[] = [orderBy('createdAt', 'desc')]
    // const q = query(this.picturesCollection, ...clauses, limit(20), startAfter(this.lastArrayDoc));
    // const snapshot = await getDocs(q);
    // console.log('snapshot docs', snapshot.docs);
    
    // this.lastArrayDoc = snapshot.docs[snapshot.docs.length - 1];
    // for (const doc of snapshot.docs) {
    //   this.array.push({ ...doc.data(), id: doc.id });
    // }

    // const observable = collectionData(q, { idField: 'id' });
    // observable.subscribe(data => {
    //   this.pictures$.next(data)
    //   resolve({
    //     status: 'available', data: this.array 
    //   });
    // });

    // });
  }

  async updatePicture(data: any, docId: string) {   

    console.log("Got data....in service : ,",data);

    if (!docId) {
      docId = doc(this.picturesCollection).id;
    }
    data.id = docId;
    if (data?.image?.org?.includes('data:image/jpeg;base64,') || data?.image?.org?.includes('data:image/jpg;base64,') || data.image?.org.includes('data:image/png;base64,') || data.image?.org.includes('data:image/gif;base64,')) {
      data.image.org = await this.utilityService.getUrlForUploadedImage(data?.image?.org, `pictures/${data.id}/images/image.png`)
    }
    const ref = doc(this.picturesCollection, data.id)
    const { id, ...updatedData } = data;
    // let pictures = this.pictures$.getValue();
    // const index = pictures.findIndex(f => f.id == data.id)
    // if (index === -1) {
    //   pictures.push({ ...data, id })
    // } else {
    //   pictures[index] = { ...data, id }
    // }
    // this.pictures$.next(pictures)
    await this.sharedService.updateDocData(ref, updatedData);
    // return true;
  }

  async delete(id: string) {
    let picturesArr = this.pictures$.getValue();
    this.array = await picturesArr.filter(f => f.id != id);
    this.pictures$.next(this.array);
    const docRef = await doc(this.picturesCollection, `${id}`);
    return deleteDoc(docRef);
  }

}
