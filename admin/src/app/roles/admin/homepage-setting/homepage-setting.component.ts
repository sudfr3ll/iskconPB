import { HomepagesettingService } from './../../../services/homepagesetting.service';
import { Component, OnInit } from '@angular/core';
import { EditSectionComponent } from '../dialogs/edit-section/edit-section.component';
import { AddSectionComponent } from '../dialogs/add-section/add-section.component';
import { MatDialog } from '@angular/material/dialog';
import { MatSnackBar } from '@angular/material/snack-bar';
import { Subscription } from 'rxjs';
import { addDoc, CollectionReference, doc, DocumentData, Firestore, getDoc, getDocs, updateDoc, deleteDoc, setDoc, collectionData, QueryConstraint, query, where, orderBy } from '@angular/fire/firestore';
import { SharedService } from 'src/app/services/shared.service';
import { collection, serverTimestamp } from '@firebase/firestore';


@Component({
  selector: 'app-homepage-setting',
  templateUrl: './homepage-setting.component.html',
  styleUrls: ['./homepage-setting.component.scss']
})
export class HomepageSettingComponent implements OnInit {
  private pagesCollection: CollectionReference<DocumentData>;
  private widgetsCollection: CollectionReference<DocumentData>;


  sections: any;
  sectionsSub: Subscription | undefined;
  showLoader: boolean = false;
  constructor(public dialog: MatDialog, public homepagesettingService: HomepagesettingService, private sharedService: SharedService,
    private snackbar: MatSnackBar,
    private firestore: Firestore,) {
    this.pagesCollection = collection(this.firestore, "Pages");
    this.widgetsCollection = collection(this.firestore, "Widgets");

  }

  async ngOnInit() {
    await this.getSections()
    console.log(this.sections)
  }

  async getSections() {
    this.sections = await this.homepagesettingService.getSections();
    this.sections = this.sections

    console.log(this.sections)

  }

  async addNewSection(section: any) {
    const dialogRef = this.dialog.open(AddSectionComponent, {
      maxWidth: '80%',
      minWidth: 'fit-content',
      data: {
        sections: this.sections.sections
      }
    });

    dialogRef.afterClosed().subscribe(async result => {

      const ref = doc(this.pagesCollection, "Homepage")
      console.log('result', result)
      console.log('resultData', result.data)
      this.sections.sections.push(result.data)
      console.log('this.sections', this.sections)
      console.log('this.sections.sections', this.sections.sections)
      await this.sharedService.updateDocData(ref, this.sections);
    
      await this.getSections()
      this.snackbar.open('Section Saved Successfully', 'OK', { duration: 3000 });
    });

  }

  onDeleteSection() {
  }

  async editSection(section: any) {
    const sectionClone = JSON.parse(JSON.stringify(section))
    const dialogRef = this.dialog.open(EditSectionComponent, {
      maxWidth: '80%',
      minWidth: 'fit-content',
      data: {
        section: sectionClone
      }
    })

    dialogRef.afterClosed().subscribe(async result => {
      console.log('asdfghjklkjhgfddfhjk')
      console.log('result', result)
      section.name = result.name

      const ref = doc(this.pagesCollection, "Homepage")
      await this.sharedService.updateDocData(ref, this.sections);

      for (let i = 0; i < this.sections.sections.length; i++) {
        if (result.widgetId == this.sections.sections[i].widgetId) {
          this.sections.sections[i].name = result.name
        }
      }

      this.showLoader = true;
      await this.getSections()
      this.snackbar.open('Section Saved Successfully', 'OK', { duration: 3000 });
      this.showLoader = false;
    });
  }

  async deleteSection(id: any) {
    const ref = doc(this.pagesCollection, "Homepage")
    this.sections.sections = this.sections.sections.filter((el: { widgetId: any; }) => el.widgetId !== id)
    await this.sharedService.updateDocData(ref, this.sections);
    await this.getSections()
    return this.sections.sections
    
  }




}
