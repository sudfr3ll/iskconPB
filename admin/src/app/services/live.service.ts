import { Injectable } from '@angular/core';
import { collection, CollectionReference, doc, DocumentData, Firestore, getDoc, updateDoc } from '@angular/fire/firestore';
import { serverTimestamp } from '@firebase/firestore';


@Injectable({
  providedIn: 'root'
})
export class LiveService {

  private liveCollection: CollectionReference<DocumentData>;

  constructor(
    private firestore: Firestore,
  ) { 
    this.liveCollection = collection(this.firestore, "Live");
  }

  async getDarshanData() {
    const ref = doc(this.liveCollection, "Darshan");
    const objs = await getDoc(ref);
    const darshanData = objs.data();
    
    return darshanData;
  }

  async updateDarshan(data: any) {
    const ref = doc(this.liveCollection, "Darshan")
    // if (updatedData.createdAt) {
      data.createdAt = serverTimestamp();
    // }
    await updateDoc(ref, data);
    return true;
  }

}
