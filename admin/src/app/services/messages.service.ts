import { Injectable } from '@angular/core';
import { addDoc, CollectionReference, doc, DocumentData, Firestore, getDoc, getDocs, updateDoc, deleteDoc, setDoc, collectionData, QueryConstraint, query, where, orderBy } from '@angular/fire/firestore';
import { collection, serverTimestamp } from '@firebase/firestore';
import { BehaviorSubject } from 'rxjs';
import { SharedService } from './shared.service';
import { UtilityService } from './utility.service';

@Injectable({
  providedIn: 'root'
})
export class MessagesService {
  messages$ = new BehaviorSubject<any[]>([]);

  private messageCollection: CollectionReference<DocumentData>;

  constructor(
    private firestore: Firestore,
    private utilityService: UtilityService,
    private sharedService: SharedService
  ) { 
    this.messageCollection = collection(this.firestore, "Message");
  }

  async getMessages() {
    return new Promise(async resolve => {
    console.log('getting docs!')
    const clauses: QueryConstraint[] = [orderBy('createdAt', 'desc')]
    const q = query(this.messageCollection, ...clauses);
    const observable = collectionData(q, { idField: 'id' });
    observable.subscribe(data => {
      this.messages$.next(data)
      resolve(true);
    });
    });
  }

  async updateMessage(data: any, docId: string) {

    if (!docId) {
      docId = doc(this.messageCollection).id;
    }
    data.id = docId;

    if (data.coverImage.includes('data:image/jpeg;base64,') || data.coverImage.includes('data:image/jpg;base64,') || data.coverImage.includes('data:image/png;base64,') || data.coverImage.includes('data:image/gif;base64,')) {
      data.coverImage = await this.utilityService.getUrlForUploadedImage(data.coverImage, `messages/${data.id}/images/image.png`)
    }
      const ref = doc(this.messageCollection, data.id)
      const { id, ...updatedData } = data;

      let messages = this.messages$.getValue();
      const index = messages.findIndex(f => f.id == data.id)
    if (index === -1) {
      messages.push({ ...data, id })
    } else {
      messages[index] = { ...data, id }
    }
      this.messages$.next(messages)

    await this.sharedService.updateDocData(ref, updatedData);
      return true;
  }

  async addMessage(data: any) {
    const docRef = await addDoc(this.messageCollection, data);
    const newDoc = await getDoc(docRef);
    return {id: newDoc.id, ...newDoc.data()}
  }
  async delete(id: string) {
 
    const docRef = await doc(this.messageCollection, `${id}`);
  
    return deleteDoc(docRef);
  }

}

