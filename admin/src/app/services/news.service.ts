import { Injectable } from '@angular/core';
import { addDoc, CollectionReference, doc, DocumentData, Firestore, getDoc, getDocs, updateDoc, deleteDoc, setDoc, collectionData, QueryConstraint, query, where, orderBy } from '@angular/fire/firestore';
import { collection, serverTimestamp } from '@firebase/firestore';
import { BehaviorSubject } from 'rxjs';
import { SharedService } from './shared.service';
import { UtilityService } from './utility.service';

@Injectable({
  providedIn: 'root'
})
export class NewsService {
  news$ = new BehaviorSubject<any[]>([]);

  private newsCollection: CollectionReference<DocumentData>;

  constructor(
    private firestore: Firestore,
    private utilityService: UtilityService,
    private sharedService: SharedService
  ) {
    this.newsCollection = collection(this.firestore, "News");
  }

  async getNews() {
    return new Promise(async resolve => {
      console.log('Getting News!');
      const clauses: QueryConstraint[] = [orderBy('createdAt', 'desc')]
      const q = query(this.newsCollection, ...clauses);
      const observable = collectionData(q, { idField: 'id' });
      observable.subscribe(data => {
        this.news$.next(data)
        resolve(true);
      });
    });
  }

  async updateNews(data: any, docId: string) {
    if (!docId) {
      docId = doc(this.newsCollection).id;
    }
    data.id = docId;

    console.log('images', data.images);

    const ref = doc(this.newsCollection, data.id)
    const { id, ...updatedData } = data;

    let news = this.news$.getValue();
    const index = news.findIndex(f => f.id == data.id)
    if (index === -1) {
      news.push({ ...data, id })
    } else {
      news[index] = { ...data, id }
    }
    this.news$.next(news)

      const imagesClone = JSON.parse(JSON.stringify(updatedData.images));
      const imagesWithoutBase64 = [];
      let imagesWithBase64 = [];
      if (imagesClone.length) {
        for (let i = 0; i < imagesClone.length; i++) {
          if (imagesClone[i].org.includes('data:image/jpeg;base64,') || imagesClone[i].org.includes('data:image/jpg;base64,') || imagesClone[i].org.includes('data:image/png;base64,') || imagesClone[i].org.includes('data:image/gif;base64,') ) {
            imagesWithBase64.push(imagesClone[i].org);
          } else {
            imagesWithoutBase64.push(imagesClone[i]);
          }
        }
      }
      updatedData.images = imagesWithoutBase64;

    await this.sharedService.updateDocData(ref, updatedData);

    if (imagesWithBase64.length) {
      for (let i = 0; i < imagesWithBase64.length; i++) {
        await this.utilityService.getUrlForUploadedImage(imagesWithBase64[i], `news/${data.id}/images/image${i + (imagesWithBase64.length || 0)}.png`);
      }
    }

    return true;
  }

  async addNews(data: any) {
    // data.createdAt = new Date()
    const docRef = await addDoc(this.newsCollection, data);
    const newDoc = await getDoc(docRef);
    return { id: newDoc.id, ...newDoc.data() }
  }

  async delete(id: string) {

    let newsArr = this.news$.getValue();
    let updatedNews = await newsArr.filter(f => f.id != id);
    this.news$.next(updatedNews);

    const docRef = await doc(this.newsCollection, `${id}`);

    return deleteDoc(docRef);
  }
}
