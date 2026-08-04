import { Injectable } from '@angular/core';
import { addDoc, CollectionReference, doc, DocumentData, Firestore, getDoc, getDocs, updateDoc, deleteDoc, setDoc, collectionData, QueryConstraint, query, where, orderBy } from '@angular/fire/firestore';
import { collection, serverTimestamp } from '@firebase/firestore';
import { BehaviorSubject } from 'rxjs';
import { SharedService } from './shared.service';
import { UtilityService } from './utility.service';

@Injectable({
  providedIn: 'root'
})
export class SubscriptionsService {

  subscriptions$ = new BehaviorSubject<any[]>([]);
  private viewSubscriptionsCollection: CollectionReference<DocumentData>;

  private subscriptionsCollection: CollectionReference<DocumentData>;

  constructor(
    private firestore: Firestore,
    private sharedService: SharedService
  ) {
    this.subscriptionsCollection = collection(this.firestore, "subscriptionTypes");
    this.viewSubscriptionsCollection = collection(this.firestore, "subscriptions");
  }

  async getSubscriptions() {
    return new Promise(async resolve => {
    const clauses: QueryConstraint[] = [orderBy('createdAt', 'desc')]
    const q = query(this.subscriptionsCollection, ...clauses);
    const observable = collectionData(q, { idField: 'id' });
    observable.subscribe(data => {
      this.subscriptions$.next(data)
      resolve(true);
    });
    });
  }

  async updateSubscription(data: any, docId: string) {

    if (!docId) {
      docId = doc(this.subscriptionsCollection).id;
    }
    data.id = docId;


      const ref = doc(this.subscriptionsCollection, data.id)
      const { id, ...updatedData } = data;

      let subscriptions = this.subscriptions$.getValue();
      const index = subscriptions.findIndex(f => f.id == data.id)
    if (index === -1) {
      subscriptions.push({ ...data, id })
    } else {
      subscriptions[index] = { ...data, id }
    }
      this.subscriptions$.next(subscriptions)

    await this.sharedService.updateDocData(ref, updatedData);
    return true;
  }

  async delete(id: string) {

    let subscriptionsArr = this.subscriptions$.getValue();
    let updatedSubscriptions = await subscriptionsArr.filter(f => f.id != id);
    this.subscriptions$.next(updatedSubscriptions);

    const docRef = await doc(this.subscriptionsCollection, `${id}`);

    return deleteDoc(docRef);
  }

  async getAllSubscriptions() {
    // console.log('getting quotes!')
    // let arr: any = [];
    // const q = await getDocs(this.viewSubscriptionsCollection)
    // q.forEach((doc) => {
    //   arr.push({
    //     id: doc.id,
    //     ...doc.data()
    //   })
    // });
    // return arr;
    return new Promise((resolve) => {
      const clauses: QueryConstraint[] = [orderBy('createdAt', 'desc')]
      const q = query(this.viewSubscriptionsCollection, ...clauses);
      const observable = collectionData(q, { idField: 'id' });
      observable.subscribe(data => {
        console.log('data', data);
        resolve(data);
      });
    })
  }
}
