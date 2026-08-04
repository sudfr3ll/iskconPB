import { SharedService } from 'src/app/services/shared.service';
import { Component, Inject, OnInit, QueryList, ViewChildren, HostListener } from '@angular/core';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { MatRadioChange } from '@angular/material/radio';
import { MatSnackBar } from '@angular/material/snack-bar';
import { HomepagesettingService } from 'src/app/services/homepagesetting.service';
import { addDoc, CollectionReference, doc, DocumentData, Firestore, getDoc, getDocs, updateDoc, deleteDoc, setDoc, collectionData, QueryConstraint, query, where, orderBy } from '@angular/fire/firestore';
import { collection, serverTimestamp } from '@firebase/firestore';
import { Subscription } from 'rxjs';

@Component({
  selector: 'app-edit-section',
  templateUrl: './edit-section.component.html',
  styleUrls: ['./edit-section.component.scss']
})
export class EditSectionComponent implements OnInit {
  @ViewChildren('checkBox')
  checkBox!: QueryList<any>;
  checked: any = [];
  checkedArray: any = [];
  showLoader: boolean = false;
  collectionData: any;
  widgetsData: any;
  checkedDataId: any;
  name: any;
  arr: any;
  widgetSub: Subscription | undefined;
  isXyzChecked: true | undefined;
  dataSub: any;

  private widgetsCollection: CollectionReference<DocumentData>;


  constructor(
    @Inject(MAT_DIALOG_DATA) public data: any,
    private dialogRef: MatDialogRef<EditSectionComponent>,
    private firestore: Firestore,
    private sharedService: SharedService,
    private homepagesettingService: HomepagesettingService
  ) {
    this.dialogRef.disableClose = true;
    this.widgetsCollection = collection(this.firestore, "Widgets");

  }

  async ngOnInit() {
    // console.log(this.data.section)
    await this.getWidgetsData()
    // this.dataSub = this.getCollectionData(this.data.section.type).subscribe((data: any) => {
    //   this.collectionData = data;

    //   for (let doc of this.collectionData) {
    //     this.checkedArray.push({
    //       checked: true,
    //       value: "",
    //       id: doc.id
    //     })
    //   }
    // });
    await this.getCollectionData(this.data.section.type);
    for (let doc of this.collectionData) {
      // doc.id
      // console.log(doc)

      for (let i = 0; i < this.widgetsData.length; i++) {
        if (this.data.section.widgetId == this.widgetsData[i]?.id) {
          let xyz = this.widgetsData[i]?.list
          // console.log('xyz', xyz)
          for (let j = 0; j < xyz?.length; j++) {
            // console.log('xyz[j]', xyz[j])

            // this.collectionData
            if (doc.id == xyz[j]) {
              // console.log('sdfghjk')
              // this.checkedArray.push(doc)
              this.checkedArray.push({
                'checked': true,
                'value': doc
              });

              doc.checked = true;
              // console.log('this.checkedArray', this.checkedArray)
            }
          }




        }
      }


    }

    // await this.checkedArrayValue()
    if (!this.data.section) {
      this.data.section = {
        name: '',
        type: ''
      }
    }
  }

  async getCollectionData(col: any) {
    let arr: any = []
    const colRef = collection(this.firestore, col);
    console.log(colRef)
    const docsSnap = await getDocs(colRef);
    // console.log(docsSnap)
    docsSnap.forEach(doc => {
      arr.push({
        id: doc.id,
        ...doc.data()
      })
    });

    this.collectionData = arr

    console.log(this.collectionData);

    // return collectionData(colRef, {
    //   idField: 'id'
    // });

    // try {
    //   let arr: any = []
    //   const docsSnap = await getDocs(colRef);
    //   docsSnap.forEach(doc => {
    //     arr.push({
    //       id: doc.id,
    //       ...doc.data()
    //     })
    //     this.collectionData = arr
    //   })
    // } catch (error) {
    //   // console.log(error);
    // }

    return this.collectionData

  }

  // async checkedArrayValue() {
  //   const abc = this.widgetsData.filter((el: { id: any; }) => el.id === this.data.section.widgetId)
  //   this.arr = abc[0].list
  //   console.log(this.arr)
  // }

  onSelectCheckbox(checkbox: any, data: any) {
    //  let mp = new Map();
    this.checked = this.checkBox.filter(checkbox => checkbox.value.checked);
    // console.log('this.checkBox', this.checked)

    this.checkedArray.forEach((o: any) => {
      this.checkedDataId = o.value.id
      // console.log(o.value)
      // console.log(data.value)
    })

    this.checked.forEach((data: { checked: any; value: any; }) => {
      // console.log(data)
      // console.log('checkedArray',this.checkedArray)

      if (data.value?.id !== this.checkedDataId) {
        // console.log('trueeeeeee', data.value.id)
        this.checkedArray.push({
          'checked': data.checked,
          'value': data.value
        })
      }
    });



    // console.log(this.checked)
  }

  async getWidgetsData() {
    this.widgetsData = await this.homepagesettingService.getWidgets()


    const widgetsData = this.homepagesettingService.widgets$.getValue();

    if (!widgetsData.length) {
      await this.homepagesettingService.getWidgets();

    }

    this.widgetSub = this.homepagesettingService.widgets$.subscribe(widgetsData => {
      this.widgetsData = widgetsData;
      // console.log(this.widgetsData)
    });
  }

  removeDuplicate(data: any[]) {
    console.log('asdfghjklkjhgfds')
    return data.filter((value: any, index: any) => data.indexOf(value) === index)
    // console.log(this.arr)
  }

  async onClickSave(ev: any) {
    ev.target.disabled = true;
    this.arr = this.checkedArray.map((item: any) => item.value?.id)

    this.arr = this.removeDuplicate(this.arr)
    console.log('this.arr', this.arr)
    console.log('this.data.section.widgetId', this.data.section.widgetId)
    await updateDoc(doc(this.widgetsCollection, this.data.section.widgetId), { list: this.arr });
    console.log('this.data.section', this.data.section)
    this.data.section = ({ ...this.data.section, name: this.data.section.name })
    console.log('his.data.section', this.data.section)
    console.log('close')
    this.dialogRef.close(this.data.section);
  }

  close(){
    this.dialogRef.close()
  }

  ngOnDestroy() {
    // this.dataSub.unsubscribe();
  }
}
