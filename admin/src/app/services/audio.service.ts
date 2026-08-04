import { SharedService } from './shared.service';
import { Injectable } from '@angular/core';
import { addDoc, CollectionReference, doc, DocumentData, Firestore, getDoc, getDocs, updateDoc, deleteDoc, setDoc, collectionData, QueryConstraint, query, where, orderBy } from '@angular/fire/firestore';
import { collection, serverTimestamp } from '@firebase/firestore';
import { BehaviorSubject } from 'rxjs';
import { UtilityService } from './utility.service';
import { getDownloadURL, getStorage, ref, uploadBytesResumable, uploadString } from "@angular/fire/storage";

@Injectable({
    providedIn: 'root'
})
export class AudioService {
    showAudioUploadProgress: any;

    audios$ = new BehaviorSubject<any[]>([]);
 
    // storageRef: any = firebase.storage().ref();
  

    private audioCollection: CollectionReference<DocumentData>;

    constructor(
        private firestore: Firestore,
        private utilityService: UtilityService,
        private sharedService: SharedService
    ) {
        this.audioCollection = collection(this.firestore, "Audios");
    }

    async getAudios() {
        return new Promise(async resolve => {
        // const q = await getDocs(this.audioCollection)
        // q.forEach((doc) => {
        //     arr.push({
        //         id: doc.id,
        //         ...doc.data()
        //     })
        // });
        const clauses: QueryConstraint[] = [orderBy('createdAt', 'desc')]
        const q = query(this.audioCollection, ...clauses);
        const observable = collectionData(q, {idField: 'id'});
        observable.subscribe(data => {
            this.audios$.next(data)
            resolve(true);
        });
        });
        // return arr;
    }

    async updateAudios(data: any, docId: string) {
 
        if(!docId) {
            docId = doc(this.audioCollection).id;
        }

        // if (data.coverImage.includes('data:image/jpeg;base64,') || data.coverImage.includes('data:image/jpg;base64,') || data.coverImage.includes('data:image/png;base64,')) {
        //     data.coverImage = await this.utilityService.getUrlForUploadedImage(data.coverImage, `audios/${data.id}/audio/${new Date().getTime().toString()}.png`)
        // }

        data.id = docId;


        if (data.url.type === 'audio/mpeg'){
               const audioUrl = await  this.uploadAudio(data);
               data.url = audioUrl;
        }
        const refDoc = doc(this.audioCollection, docId);
        const { id, ...updatedData } = data;
        // let audios = this.audios$.getValue();
        // const index = audios.findIndex(f => f.id == id)
        // if (index === -1) {
        //     audios.push({ ...data, id })
        // } else {
        //     audios[index] = { ...data, id }
        // }
        // this.audios$.next(audios);
        await this.sharedService.updateDocData(refDoc, updatedData);
        return true;
    }

    uploadAudio(data: any) {
        return new Promise(async (resolve, reject) => {
            const storage = getStorage();
            const metadata = {
                contentType: 'audio/mp3',
            };
            const storageRef = ref(storage, `audios/${data.id}/audios/${data.url.name}`);

            const uploadTask = uploadBytesResumable(storageRef, data.url, metadata);
            uploadTask.on("state_changed",
                (snapshot) => {
                    // Observe state change events such as progress, pause, and resume
                    // Get task progress, including the number of bytes uploaded and the total number of bytes to be uploaded
                    // const progress = (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
                    this.showAudioUploadProgress = (snapshot.bytesTransferred / snapshot.totalBytes) * 100;

                    switch (snapshot.state) {
                        case 'paused':
                            break;
                        case 'running':
                            break;
                    }
                },
                (error) => {
                    // Handle unsuccessful uploads
                },
                () => {
                    // Handle successful uploads on complete
                    // For instance, get the download URL: https://firebasestorage.googleapis.com/...
                    getDownloadURL(uploadTask.snapshot.ref).then((downloadURL) => {
                        resolve(downloadURL);
                    });
                }
            );
        })
    }
    
    async delete(id: string) {

        let audiosArr = this.audios$.getValue();
        let updatedAudios = await audiosArr.filter(f => f.id != id);
        this.audios$.next(updatedAudios);

        const docRef = await doc(this.audioCollection, `${id}`);

        return deleteDoc(docRef);
    }
    
   

}
