import { Injectable } from '@angular/core';
import { addDoc, CollectionReference, doc, DocumentData, Firestore, getDoc, getDocs, updateDoc, deleteDoc, setDoc, collectionData, QueryConstraint, query, where, orderBy } from '@angular/fire/firestore';
import { collection, serverTimestamp } from '@firebase/firestore';
import { BehaviorSubject } from 'rxjs';
import { SharedService } from './shared.service';
import { UtilityService } from './utility.service';

@Injectable({
  providedIn: 'root'
})
export class EventsService {
  events$ = new BehaviorSubject<any[]>([]);

  private eventsCollection: CollectionReference<DocumentData>;

  constructor(
    private firestore: Firestore,
    private utilityService: UtilityService,
    private sharedService: SharedService
  ) { 
    this.eventsCollection = collection(this.firestore, "Events");
  }

  async getEvents() {
    return new Promise(async resolve => {
      console.log('getting events!')
      const clauses: QueryConstraint[] = [orderBy('createdAt', 'desc')]
      const q = query(this.eventsCollection, ...clauses);
      const observable = collectionData(q, { idField: 'id' });
      observable.subscribe(data => {
        this.events$.next(data)
        resolve(true);
      });
    })
  }

  async updateEvent(data: any, docId: string) { 

    if (!docId) {
      docId = doc(this.eventsCollection).id;
    }
    data.id = docId;

    if (data.coverImage.includes('data:image/jpeg;base64,') || data.coverImage.includes('data:image/jpg;base64,') || data.coverImage.includes('data:image/png;base64,') || data.coverImage.includes('data:image/gif;base64,')) {
      data.coverImage = await this.utilityService.getUrlForUploadedImage(data.coverImage, `events/${data.id}/images/image.png`)
    }
    const ref = doc(this.eventsCollection, data.id)
    const { id, ...updatedData } = data;

    let events = this.events$.getValue();
    const index = events.findIndex(f => f.id == data.id)
    if (index === -1) {
      events.push({ ...data, id })
    } else {
      events[index] = { ...data, id }
    }
    this.events$.next(events)
    await this.sharedService.updateDocData(ref, updatedData);

    return true;
  }

  async addEvent(data: any) {
    // data.createdAt = new Date()
    const docRef = await addDoc(this.eventsCollection, data);
    const newDoc = await getDoc(docRef);
    return {id: newDoc.id, ...newDoc.data()}
  }

  async delete(id: string) {

    let eventsArr = this.events$.getValue();
    let updatedEvents = await eventsArr.filter(f => f.id != id);
    this.events$.next(updatedEvents);

    const docRef = await doc(this.eventsCollection, `${id}`);

    return deleteDoc(docRef);
  }
}
