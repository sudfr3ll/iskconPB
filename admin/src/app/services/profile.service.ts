import { Injectable } from '@angular/core';
import { Firestore } from '@angular/fire/firestore';
import { doc, docData } from '@angular/fire/firestore';
import { Observable } from 'rxjs';
import { UtilityService } from './utility.service';

@Injectable({
  providedIn: 'root'
})
export class ProfileService {

  constructor(
    private firestore: Firestore,
    private utilityService: UtilityService,
  ) { }

  async getUserData() {
    const userId = localStorage.getItem("userId");
    const requestData = doc(this.firestore, `admins/${userId}`);
    let obs = docData(requestData, { idField: 'id' }) as Observable<any>;
    let userData: any = await this.utilityService.convertObsToValue(obs);
    return userData || null;
  }
}
