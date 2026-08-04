import { Component, OnInit, Inject } from '@angular/core';
import { MatDialog, MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { SharedService } from '../services/shared.service';
import { addDoc, CollectionReference, doc, DocumentData, Firestore, getDoc, getDocs, updateDoc, deleteDoc } from '@angular/fire/firestore';
import { collection } from '@firebase/firestore';



@Component({
  selector: 'app-delete-confirmation-modal',
  templateUrl: './delete-confirmation-modal.component.html',
  styleUrls: ['./delete-confirmation-modal.component.scss']
})
export class DeleteConfirmationModalComponent implements OnInit {

  collection = collection(this.firestore, this.data.collection)

  constructor(public dialogRef: MatDialogRef<DeleteConfirmationModalComponent>,
    @Inject(MAT_DIALOG_DATA) public data: any, private sharedService: SharedService, private firestore: Firestore,) { }

 ngOnInit(): void {
    // console.log('dataaa', this.data.collection)
  }

  onClickDelete() {
    this.data.ids.forEach(async (id: any) => {
      // console.log('iddddddddddddd',id)
      
      const docRef = await doc(this.collection, `${id}`);

      return deleteDoc(docRef);
     
    })
  }

}
