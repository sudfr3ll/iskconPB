import { Injectable } from '@angular/core';
import { addDoc, CollectionReference, doc, DocumentData, Firestore, getDoc, getDocs, updateDoc, deleteDoc, setDoc, collectionData, QueryConstraint, query, where, orderBy } from '@angular/fire/firestore';
import { collection, serverTimestamp } from '@firebase/firestore'; import { BehaviorSubject } from 'rxjs';
import { UtilityService } from './utility.service';

@Injectable({
  providedIn: 'root'
})
export class CategoriesService {
  level1$ = new BehaviorSubject<any[]>([]);
  level2$ = new BehaviorSubject<any[]>([]);
  level3$ = new BehaviorSubject<any[]>([]);

  private categoryOneCollection: CollectionReference<DocumentData>;
  private categoryTwoCollection: CollectionReference<DocumentData>;
  private categoryThreeCollection: CollectionReference<DocumentData>;

  constructor(
    private firestore: Firestore,
    private utilityService: UtilityService
  ) {
    this.categoryOneCollection = collection(this.firestore, "Categories-L1");
    this.categoryTwoCollection = collection(this.firestore, "Categories-L2");
    this.categoryThreeCollection = collection(this.firestore, "Categories-L3")
  }

  async getCategoryOne() {
    return new Promise<any>(async resolve => {
      const clauses: QueryConstraint[] = [orderBy('createdAt', 'desc')]
      const q = query(this.categoryOneCollection, ...clauses);
      const observable = collectionData(q, { idField: 'id' });
      observable.subscribe(arr => {
        console.log('sub cat 1', arr)
        this.level1$.next(arr)
        resolve(arr);
      });
    });
  }

  async getCategoryOneWithId(id: any) {
    let arr: any = [];
    const cat = await getDocs(this.categoryOneCollection);
    cat.forEach((doc) => {
      arr.push({
        id: doc.id,
        ...doc.data()
      })
    });
    this.level1$.next(arr)
    return arr;
  }

  async getCategoryTwo() {
    return new Promise<any>(async resolve => {
      const clauses: QueryConstraint[] = [orderBy('createdAt', 'desc')]
      const q = query(this.categoryTwoCollection, ...clauses);
      const observable = collectionData(q, { idField: 'id' });
      observable.subscribe(arr => {
        this.level2$.next(arr)
        resolve(arr);
      });
    });
  }


  async getCategoryThree() {
    let arr: any = [];
    const cat = await getDocs(this.categoryThreeCollection);
    cat.forEach((doc) => {
      arr.push({
        id: doc.id,
        ...doc.data()
      })
    });
    this.level3$.next(arr)
    return arr;
  }

  async getCategoryTwoWithId(id: string) {
    let arr: any = [];

    const whereClauses: QueryConstraint[] = [where('categoryId_L1', '==', id)]
    const q = query(this.categoryTwoCollection, ...whereClauses);
    // return getDocs(q)

    const cat = await getDocs(q);
    cat.forEach((doc) => {
      arr.push({
        id: doc.id,
        ...doc.data()
      })
    });
    this.level2$.next(arr)
    return arr;
  }


  async getCategoryThreeWithId(id: string, id2: string) {
    // console.log('getting category 3');
    let arr: any = [];

    const whereClauses: QueryConstraint[] = [where('categoryId_L1', '==', id), where('categoryId_L2', '==', id2)]
    const q = query(this.categoryThreeCollection, ...whereClauses);
    // return getDocs(q)

    const cat = await getDocs(q);
    cat.forEach((doc) => {
      arr.push({
        id: doc.id,
        ...doc.data()
      })
    });
    this.level3$.next(arr)
    return arr;
  }

  async addCategory1(data: any) {
    // data.createdAt = new Date()
    const docRef = await addDoc(this.categoryOneCollection, data);
    const newDoc = await getDoc(docRef);
    return { id: newDoc.id, ...newDoc.data() }
  }

  async updateCategory1(data: any, docId: string) {
    let mode = docId ? 'edit' : 'add';

    if (!docId) {
      docId = doc(this.categoryOneCollection).id;
    }
    data.id = docId;

    console.log('docid in cat 1', docId)

    if (data.coverImage.includes('data:image/jpeg;base64,') || data.coverImage.includes('data:image/jpg;base64,') || data.coverImage.includes('data:image/png;base64,') || data.coverImage.includes('data:image/gif;base64,')) {
      data.coverImage = await this.utilityService.getUrlForUploadedImage(data.coverImage, `categoryOne/${data.id}/images/image.png`)
    }
    // console.log(data.id)
    const ref = doc(this.categoryOneCollection, data.id)
    const { id, ...updatedData } = data;

    let level1 = this.level1$.getValue();
    const index = level1.findIndex(f => f.id == data.id)
    if (index === -1) {
      level1.push({ ...data, id })
    } else {
      level1[index] = { ...data, id }
    }
    this.level1$.next(level1)

    // await setDoc(ref, updatedData);

    if (mode === 'edit') {
      if (updatedData.createdAt) {
        updatedData.createdAt = serverTimestamp();
      }
      await updateDoc(ref, updatedData);
    } else {
      if (updatedData.createdAt) {
        updatedData.createdAt = serverTimestamp();
      }
      await setDoc(ref, updatedData);
    }
    return true;
  }



  async addCategory2(data: any) {
    // data.createdAt = new Date()
    const docRef = await addDoc(this.categoryTwoCollection, data);
    const newDoc = await getDoc(docRef);
    return { id: newDoc.id, ...newDoc.data() }
  }


  async updateCategory2(data: any, docId: string) {
    let mode = docId ? 'edit' : 'add';

    if (!docId) {
      docId = doc(this.categoryTwoCollection).id;
    }
    data.id = docId;

    console.log('docid in cat 2', docId)

    if (data.coverImage.includes('data:image/jpeg;base64,') || data.coverImage.includes('data:image/jpg;base64,') || data.coverImage.includes('data:image/png;base64,') || data.coverImage.includes('data:image/gif;base64,')) {
      data.coverImage = await this.utilityService.getUrlForUploadedImage(data.coverImage, `categoryTwo/${data.id}/images/image.png`)
    }
    // console.log(data.id)
    const ref = doc(this.categoryTwoCollection, data.id)
    const { id, ...updatedData } = data;

    let level2 = this.level2$.getValue();
    const index = level2.findIndex(f => f.id == data.id)
    if (index === -1) {
      level2.push({ ...data, id })
    } else {
      level2[index] = { ...data, id }
    }
    this.level2$.next(level2)

    // await setDoc(ref, updatedData);

    if (mode === 'edit') {
      if (updatedData.createdAt) {
        updatedData.createdAt = serverTimestamp();
      }
      await updateDoc(ref, updatedData);
    } else {
      if (updatedData.createdAt) {
        updatedData.createdAt = serverTimestamp();
      }
      await setDoc(ref, updatedData);
    }   
     return true;

  }

  async updateCategory3(data: any, docId: string) {
    let mode = docId ? 'edit' : 'add';

    if (!docId) {
      docId = doc(this.categoryThreeCollection).id;
    }
    data.id = docId;

    if (data.coverImage.includes('data:image/jpeg;base64,') || data.coverImage.includes('data:image/jpg;base64,') || data.coverImage.includes('data:image/png;base64,') || data.coverImage.includes('data:image/gif;base64,')) {
      data.coverImage = await this.utilityService.getUrlForUploadedImage(data.coverImage, `categoryThree/${data.id}/images/image.png`)
    }

    const ref = doc(this.categoryThreeCollection, data.id)
    const { id, ...updatedData } = data;

    let level3 = this.level3$.getValue();
    const index = level3.findIndex(f => f.id == data.id)
    if (index === -1) {
      level3.push({ ...data, id })
    } else {
      level3[index] = { ...data, id }
    }
    this.level3$.next(level3)
    if (mode === 'edit') {
      if (updatedData.createdAt) {
        updatedData.createdAt = serverTimestamp();
      }
      await updateDoc(ref, updatedData);
    } else {
      if (updatedData.createdAt) {
        updatedData.createdAt = serverTimestamp();
      }
      await setDoc(ref, updatedData);
    }

    return true;
  }

  async deleteCategory1(id: string) {

    let level1Arr = this.level1$.getValue();
    let updatedCategory = await level1Arr.filter(f => f.id != id);
    this.level1$.next(updatedCategory);

    const docRef = await doc(this.categoryOneCollection, `${id}`);

    return deleteDoc(docRef);
  }

  async deleteCategory2(id: string) {

    let level2Arr = this.level2$.getValue();
    let updatedCategory = await level2Arr.filter(f => f.id != id);
    this.level2$.next(updatedCategory);

    const docRef = await doc(this.categoryTwoCollection, `${id}`);

    return deleteDoc(docRef);
  }

  async deleteCategory3(id: string) {
    let level3Arr = this.level3$.getValue();
    let updatedCategory = await level3Arr.filter(f => f.id != id);
    this.level3$.next(updatedCategory);
    const docRef = await doc(this.categoryThreeCollection, `${id}`);

    return deleteDoc(docRef);
  }


}
