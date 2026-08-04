import { Injectable } from '@angular/core';
import { addDoc, CollectionReference, doc, DocumentData, Firestore, getDoc, getDocs, updateDoc, deleteDoc, setDoc, collectionData, QueryConstraint, query, where, orderBy } from '@angular/fire/firestore';
import { collection, serverTimestamp } from '@firebase/firestore';
import { BehaviorSubject } from 'rxjs';
import { SharedService } from './shared.service';
import { UtilityService } from './utility.service';

@Injectable({
  providedIn: 'root'
})
export class FestivalsService {
  festivals$ = new BehaviorSubject<any[]>([]);

  private festivalsCollection: CollectionReference<DocumentData>;

  constructor(
    private firestore: Firestore,
    private utilityService: UtilityService,
    private sharedService: SharedService
  ) {
    this.festivalsCollection = collection(this.firestore, "Festivals");
  }

  async getFestivals() {
    return new Promise(async resolve => {
      console.log('getting festivals!');
      const clauses: QueryConstraint[] = [orderBy('createdAt', 'desc')]
      const q = query(this.festivalsCollection, ...clauses);
      const observable = collectionData(q, { idField: 'id' });
      observable.subscribe(data => {
        this.festivals$.next(data)
        resolve(true);
      });
    });
  }

  async updateFestivals(data: any, docId: string) {

    if (!docId) {
      docId = doc(this.festivalsCollection).id;
    }
    data.id = docId;

    if (data.coverImage.includes('data:image/jpeg;base64,') || data.coverImage.includes('data:image/jpg;base64,') || data.coverImage.includes('data:image/png;base64,') || data.coverImage.includes('data:image/gif;base64,')) {
      data.coverImage = await this.utilityService.getUrlForUploadedImage(data.coverImage, `festivals/${data.id}/images/image.png`)
    }
    const ref = doc(this.festivalsCollection, data.id)
    const { id, ...updatedData } = data;

    let festivals = this.festivals$.getValue();


    const index = festivals.findIndex(f => f.id == data.id)
    if (index === -1) {
      festivals.push({ ...data, id })
    } else {
      festivals[index] = { ...data, id }
    }
    this.festivals$.next(festivals)

    await this.sharedService.updateDocData(ref, updatedData);
    return true;
  }

  async addFestival(data: any) {
    // data.createdAt = new Date()
    const docRef = await addDoc(this.festivalsCollection, data);
    const newDoc = await getDoc(docRef);
    return { id: newDoc.id, ...newDoc.data() }
  }

  async delete(id: string) {

    let festivalsArr = this.festivals$.getValue();
    let updatedFestivals = await festivalsArr.filter(f => f.id != id);
    this.festivals$.next(updatedFestivals);

    const docRef = await doc(this.festivalsCollection, `${id}`);

    return deleteDoc(docRef);
  }
}

