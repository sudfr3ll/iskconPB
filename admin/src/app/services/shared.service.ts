import { Injectable } from '@angular/core';
import { setDoc } from '@angular/fire/firestore';
import { collection, serverTimestamp } from '@firebase/firestore';
import { MatCheckboxChange } from '@angular/material/checkbox';
import { MatDialog, MatDialogRef } from '@angular/material/dialog';
import { DeleteConfirmationModalComponent } from 'src/app/delete-confirmation-modal/delete-confirmation-modal.component';

@Injectable({
  providedIn: 'root'
})
export class SharedService {
  check: boolean = false;
  showHeader: any = false;
  indeterminate = false;
  checked = true;
  count: any;
  selectedIdsToDeleteArray: any = [];

  constructor(
    public dialog: MatDialog) { }

  async updateDocData(ref: any, updatedData: any) {
    console.log('updatedData', updatedData)
    return new Promise(async resolve => {
      if (updatedData.createdAt) {
        updatedData.createdAt = serverTimestamp();
      }
      await setDoc(ref, updatedData);
      resolve(true);
    });
  }

  async updateHomepageDocData(ref: any, updatedData: any) {
    return new Promise(async resolve => {
      if (updatedData.createdAt) {
        updatedData.createdAt = serverTimestamp();
      }
      await setDoc(ref, { ...updatedData });
      resolve(true);
    });
  }

  onSelectCheckBox(ob: MatCheckboxChange, item: any, data: any) {
    if (!ob.checked) {
      this.selectedIdsToDeleteArray = this.selectedIdsToDeleteArray.filter((el: any) => item.id !== el);
      item.checked = false;
      this.count = this.selectedIdsToDeleteArray.length;
      if (this.count != data.length) {
        this.indeterminate = false
      } else if (this.count == data.length) {
        this.indeterminate = true
      }
      if (this.count == 0) {
        this.check = false
        this.showHeader = false
        this.indeterminate = false
      }
    } else {
      this.showHeader = true
      if (!this.selectedIdsToDeleteArray.includes(item.id)) {

        this.selectedIdsToDeleteArray.push(item.id);
        this.count = this.selectedIdsToDeleteArray.length

        if (this.count != data.length) {
          this.indeterminate = false
        } else if (this.count == data.length) {
          this.indeterminate = true
        }
      }
      item.checked = true;
    }

    return { showHead: this.showHeader, indeterminate: this.indeterminate, count: this.count }

  }

  onClickSelectAllCheckBox(ob: MatCheckboxChange, data: any) {

    if (ob.checked) {
      this.count = this.selectedIdsToDeleteArray.length;
      data.forEach((item: {
        id: string, checked: any;
      }) => {

        item.checked = true;

        if (!this.selectedIdsToDeleteArray.includes(item.id)) {

          this.selectedIdsToDeleteArray.push(item.id);
          this.count = this.selectedIdsToDeleteArray.length


          if (this.count != data.length) {
            this.indeterminate = false
          } else if (this.count == data.length) {
            this.indeterminate = true
          }


        }
        this.showHeader = true

        // }
      })
    } else {
      this.selectedIdsToDeleteArray = [];
      data.forEach((item: any) => {
        item.checked = false;
        this.count = this.selectedIdsToDeleteArray.length
        this.showHeader = false
        this.indeterminate = false
      });

    }

    return { showHead: this.showHeader, indeterminate: this.indeterminate, count: this.count }
  }

  onClickCross(data: any) {
    this.indeterminate = false;
    this.showHeader = false
    this.selectedIdsToDeleteArray = [];
    this.count = 0
    for (let item of data) {
      item.checked = false;
    }

    return { showHead: this.showHeader, indeterminate: this.indeterminate, count: this.count }
  }

  openDeleteConfirmationModal(Collection: any): void {
    const dialogRef = this.dialog.open(DeleteConfirmationModalComponent, {
      width: '400px',
      data: {
        ids: this.selectedIdsToDeleteArray, collection: Collection
      }
    });
    dialogRef.afterClosed().subscribe(async result => {
    });
  }

  deleteSingleDoc(id: any, Collection: any) {
    const dialogRef = this.dialog.open(DeleteConfirmationModalComponent, {
      width: '400px',
      data: {
        ids: [id], collection: Collection
      }
    });
    dialogRef.afterClosed().subscribe(async result => {

    });
  }

  getImage(data: any) {

    if (data.resizedCoverImage) {
      // console.log('resized coverimg')
      return data.resizedCoverImage.thumb
    }
    // } else{
    // console.log('coverimg')
    return data.coverImage

  }

}
