import { Injectable } from '@angular/core';
import { addDoc, CollectionReference, doc, DocumentData, Firestore, getDoc, getDocs, updateDoc, deleteDoc, setDoc, collectionData, QueryConstraint, query, where, orderBy } from '@angular/fire/firestore';
import { collection, serverTimestamp } from '@firebase/firestore';
import { BehaviorSubject } from 'rxjs';
import { SharedService } from './shared.service';
import { UtilityService } from './utility.service';

@Injectable({
  providedIn: 'root'
})
export class VideosService {

  videos$ = new BehaviorSubject<any[]>([]);

  private videosCollection: CollectionReference<DocumentData>;

  constructor(
    private firestore: Firestore,
    private utilityService: UtilityService,
    private sharedService: SharedService
  ) {
    this.videosCollection = collection(this.firestore, "Videos");
  }

  async getVideos() {
    return new Promise(async resolve => {
    console.log('getting videos!')

    const clauses: QueryConstraint[] = [orderBy('createdAt', 'desc')]
    const q = query(this.videosCollection, ...clauses);
    const observable = collectionData(q, { idField: 'id' });
    observable.subscribe(data => {
      this.videos$.next(data)
      resolve(true);
    });
    });
  }

  async updateVideo(data: any, docId: string) {

    if (!docId) {
      docId = doc(this.videosCollection).id;
    }
    data.id = docId;

    if (data.coverImage.includes('data:image/jpeg;base64,') || data.coverImage.includes('data:image/jpg;base64,') || data.coverImage.includes('data:image/png;base64,') || data.coverImage.includes('data:image/gif;base64,')) {
      data.coverImage = await this.utilityService.getUrlForUploadedImage(data.coverImage, `videos/${data.id}/images/image.png`)
    }
    const ref = doc(this.videosCollection, data.id)

    const { id, ...updatedData } = data;

    let videos = this.videos$.getValue();
    const index = videos.findIndex(f => f.id == data.id)
    if (index === -1) {
      videos.push({ ...data, id })
    } else {
      videos[index] = { ...data, id }
    }
    this.videos$.next(videos)

    await this.sharedService.updateDocData(ref, updatedData);
    return true;
  }


  async addVideo(data: any): Promise<any> {
    const docRef = await addDoc(this.videosCollection, data);
    const newDoc = await getDoc(docRef);
    return { id: newDoc.id, ...newDoc.data() }
  }


  async delete(id: string) {

    let videosArr = this.videos$.getValue();
    let updatedVideos = await videosArr.filter(f => f.id != id);
    this.videos$.next(updatedVideos);

    const docRef = await doc(this.videosCollection, `${id}`);

    return deleteDoc(docRef);
  }

}

