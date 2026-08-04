import { Injectable } from '@angular/core';
import { getDownloadURL, getStorage, ref, uploadString } from '@angular/fire/storage';
import { Observable, take } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class UtilityService {

  constructor() { }

  async getBase64FromFile(file: any) {
		return new Promise((resolve, reject) => {
			const reader = new FileReader();
			reader.readAsDataURL(file);

			reader.onload = () => {
				resolve(reader.result);
			};
			reader.onerror = (err) => {
				reject(err);
			};
		});
	}

  async getUrlForUploadedImage(base64: string, route: string) {
		return new Promise<string>(async (resolve, reject) => {
			const storage = getStorage();
			const storageRef = ref(storage, route);
			uploadString(storageRef, base64, 'data_url').then((snapshot) => {
				resolve('');
				// getDownloadURL(storageRef).then((url) => {
				// 	resolve(url);
				// });
			});
		});
	}

	async convertObsToValue(observable: Observable<any>) {
		return new Promise<any>((resolve, reject) => {
			observable.pipe(take(1)).subscribe(result => {
				resolve(result);
			})
		})
	}

	
}
