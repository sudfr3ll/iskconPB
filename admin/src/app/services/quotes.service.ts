import { Injectable } from '@angular/core';
import { addDoc, CollectionReference, doc, DocumentData, Firestore, getDoc, getDocs, updateDoc, deleteDoc, setDoc, collectionData, QueryConstraint, query, where, orderBy } from '@angular/fire/firestore';
import { collection, serverTimestamp } from '@firebase/firestore';
import { BehaviorSubject } from 'rxjs';
import { SharedService } from './shared.service';
import { UtilityService } from './utility.service';

@Injectable({
  providedIn: 'root'
})
export class QuotesService {

  quotes$ = new BehaviorSubject<any[]>([]);

  private quotesCollection: CollectionReference<DocumentData>;

  constructor(
    private firestore: Firestore,
    private sharedService: SharedService
  ) {
    this.quotesCollection = collection(this.firestore, "Quotes");
  }

  async getQuotes() {
    return new Promise(async resolve => {
    const clauses: QueryConstraint[] = [orderBy('createdAt', 'desc')]
    const q = query(this.quotesCollection, ...clauses);
    const observable = collectionData(q, { idField: 'id' });
    observable.subscribe(data => {
      this.quotes$.next(data)
      resolve(true);
    });
    });
  }

  async updateQuote(data: any, docId: string) {

    if (!docId) {
      docId = doc(this.quotesCollection).id;
    }
    data.id = docId;


      const ref = doc(this.quotesCollection, data.id)
      const { id, ...updatedData } = data;

      let quotes = this.quotes$.getValue();
      const index = quotes.findIndex(f => f.id == data.id)
    if (index === -1) {
      quotes.push({ ...data, id })
    } else {
      quotes[index] = { ...data, id }
    }
      this.quotes$.next(quotes)

    await this.sharedService.updateDocData(ref, updatedData);
    return true;
  }

  async delete(id: string) {

    let quotesArr = this.quotes$.getValue();
    let updatedQuotes = await quotesArr.filter(f => f.id != id);
    this.quotes$.next(updatedQuotes);

    const docRef = await doc(this.quotesCollection, `${id}`);

    return deleteDoc(docRef);
  }
}
