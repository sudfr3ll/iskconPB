import { Component, Inject, OnInit } from '@angular/core';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { MatRadioChange } from '@angular/material/radio';
import { MatSnackBar } from '@angular/material/snack-bar';
import { HomepagesettingService } from 'src/app/services/homepagesetting.service';
import { SharedService } from 'src/app/services/shared.service';
import { addDoc, CollectionReference, doc, DocumentData, Firestore, getDoc, getDocs, updateDoc, deleteDoc, setDoc, collectionData, QueryConstraint, query, where, orderBy } from '@angular/fire/firestore';
import { collection, serverTimestamp } from '@firebase/firestore';

@Component({
  selector: 'app-add-section',
  templateUrl: './add-section.component.html',
  styleUrls: ['./add-section.component.scss']
})
export class AddSectionComponent implements OnInit {
  private pagesCollection: CollectionReference<DocumentData>;


  newWidget: any;
  showLoader: boolean = false;
  selectedType: string | undefined;
  types: string[] = ['Events', 'Audios', 'Festivals', 'News','Blogs', 'Pictures', 'Videos'];
  widgetId: any;
  section: any

  constructor(
    @Inject(MAT_DIALOG_DATA) public data: any,
    private dialogRef: MatDialogRef<AddSectionComponent>,
    private homepagesettingService: HomepagesettingService,
    private sharedService: SharedService,
    private firestore: Firestore,
    

  ) { 
    this.dialogRef.disableClose = true;
    this.pagesCollection = collection(this.firestore, "Pages");
  }

  ngOnInit(): void {
    console.log('dataaaaa', this.data) 
    this.section = {
      name: '',
      type: '',
      widgetId: '',
    }


    // if (this.data.section[0].sections) {
    //   this.section = this.data.section[0].sections;
    // }
    // else {
    //   this.section = {
    //     type: '',
    //     widgetId: '',
    //     name: ''
    //   }
    // }
  }

  async onClickSave(){
    console.log('this.selectedType', this.selectedType)
    
    this.newWidget = await this.homepagesettingService.addWidgets({ type: this.selectedType });
    console.log(this.newWidget)

    this.widgetId = this.newWidget.id
   
    this.section = { ...this.section, widgetId: this.widgetId, type: this.selectedType }
  
    this.dialogRef.close({ data: this.section });
 
    // this.dialogRef.close({ data: this.section });

  }

  radioButtonChange(data: MatRadioChange) {
    this.selectedType = data.value
    console.log(data.value);
  }

  close(){
    this.dialogRef.close()
  }

}
