import { Injectable } from '@angular/core';
import { addDoc, CollectionReference, doc, DocumentData, Firestore, getDoc, getDocs, updateDoc, deleteDoc, setDoc, collectionData, QueryConstraint, query, where, orderBy } from '@angular/fire/firestore';
import { collection, serverTimestamp } from '@firebase/firestore';
import { BehaviorSubject } from 'rxjs';
import { SharedService } from './shared.service';
import { UtilityService } from './utility.service';

@Injectable({
  providedIn: 'root'
})
export class BlogsService {
  blogs$ = new BehaviorSubject<any[]>([]);

  private blogsCollection: CollectionReference<DocumentData>;

  constructor(
    private firestore: Firestore,
    private utilityService: UtilityService,
    private sharedService: SharedService
  ) {
    this.blogsCollection = collection(this.firestore, "Blogs");
  }

  async getBlogs() {
    return new Promise(async resolve => {
      const clauses: QueryConstraint[] = [orderBy('createdAt', 'desc')]
      const q = query(this.blogsCollection, ...clauses);
      const observable = collectionData(q, { idField: 'id' });
      observable.subscribe(data => {
        this.blogs$.next(data)
        resolve(true);
      });
    });
  

  }

  async updateBlogs(data: any, docId: string) {

    if (!docId) {
      docId = doc(this.blogsCollection).id;
    }
    data.id = docId;

    if (data.coverImage.includes('data:image/jpeg;base64,') || data.coverImage.includes('data:image/jpg;base64,') || data.coverImage.includes('data:image/png;base64,') || data.coverImage.includes('data:image/gif;base64,')) {
      data.coverImage = await this.utilityService.getUrlForUploadedImage(data.coverImage, `blogs/${data.id}/images/image.png`)
    }
    const ref = doc(this.blogsCollection, data.id)
    const { id, ...updatedData } = data;

    let blogs = this.blogs$.getValue();


    const index = blogs.findIndex(f => f.id == data.id)
    if (index === -1) {
      blogs.push({ ...data, id })
    } else {
      blogs[index] = { ...data, id }
    }
    this.blogs$.next(blogs)

    await this.sharedService.updateDocData(ref, updatedData);
    return true;
    // else {


  }

  async addblogs(data: any) {
    // data.createdAt = new Date()
    const docRef = await addDoc(this.blogsCollection, data);
    const newDoc = await getDoc(docRef);
    return { id: newDoc.id, ...newDoc.data() }
  }

  async delete(id: string) {

    let blogsArr = this.blogs$.getValue();
    let updatedBlogs = await blogsArr.filter(f => f.id != id);
    this.blogs$.next(updatedBlogs);

    const docRef = await doc(this.blogsCollection, `${id}`);

    return deleteDoc(docRef);
  }
}

