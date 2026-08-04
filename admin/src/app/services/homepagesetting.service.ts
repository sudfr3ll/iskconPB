import { Injectable } from '@angular/core';
import { addDoc, CollectionReference, doc, DocumentData, Firestore, getDoc, getDocs, updateDoc, deleteDoc, setDoc, collectionData, QueryConstraint, query, where, orderBy } from '@angular/fire/firestore';
import { collection, serverTimestamp } from '@firebase/firestore';
import { BehaviorSubject } from 'rxjs';
import { SharedService } from './shared.service';
import { UtilityService } from './utility.service';

@Injectable({
  providedIn: 'root'
})
export class HomepagesettingService {
  sections$ = new BehaviorSubject<any[]>([]);
  private pagesCollection: CollectionReference<DocumentData>;
  private widgetsCollection: CollectionReference<DocumentData>;
  widgets$ = new BehaviorSubject<any[]>([]);


  constructor(
    private firestore: Firestore,
    private utilityService: UtilityService,
    private sharedService: SharedService
  ) {
    this.pagesCollection = collection(this.firestore, "Pages");
    this.widgetsCollection = collection(this.firestore, "Widgets");
  }

  // async getSections() {
  //   return new Promise(async resolve => {
  //     const clauses: QueryConstraint[] = [orderBy('createdAt', 'desc')]
  //     const q = query(this.pagesCollection, ...clauses);
  //     const observable = collectionData(q, { idField: 'id' });
  //     observable.subscribe(data => {
  //       this.sections$.next(data)
  //       resolve(true);
  //     });
  //   });
  // }

  async getSections() {
    
    const docRef = doc(this.pagesCollection, "Homepage");
    const docSnap = await getDoc(docRef);
    docSnap.data();

    try {
      const docSnap = await getDoc(docRef);
      if (docSnap.exists()) {
      
        console.log(docSnap.data());
      } else {
        console.log("Document does not exist")
      }

    } catch (error) {
      console.log(error)
    }

    return docSnap.data()

  }
  async getWidgets() {
    return new Promise(async resolve => {
      console.log('Getting widgets!');
      const clauses: QueryConstraint[] = [orderBy('createdAt', 'desc')]
      const q = query(this.widgetsCollection, ...clauses);
      const observable = collectionData(q, { idField: 'id' });
      observable.subscribe(data => {
        this.widgets$.next(data)
        resolve(true);
        console.log(data)
      });

    });
  }

  async addWidgets(data: any) {
    console.log('fghjkl')
    const docRef = await addDoc(this.widgetsCollection, data);
    const newDoc = await getDoc(docRef);
    return { id: newDoc.id, ...newDoc.data() }
  }

  async delete(id: string) {

    let sectionsArr = this.sections$.getValue();
    let updatedSections = await sectionsArr.filter(f => f.id != id);
    this.sections$.next(updatedSections);

    const docRef = await doc(this.pagesCollection, `${id}`);

    return deleteDoc(docRef);
  }
}
