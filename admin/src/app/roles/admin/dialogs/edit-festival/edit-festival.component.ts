// import { Content } from '@angular/compiler/src/render3/r3_ast';
import { Component, Inject, OnInit } from '@angular/core';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { UtilityService } from 'src/app/services/utility.service';
import { FestivalsService } from 'src/app/services/festivals.service';
import { MatSnackBar } from '@angular/material/snack-bar';
import { serverTimestamp } from '@firebase/firestore';


@Component({
  selector: 'app-edit-festival',
  templateUrl: './edit-festival.component.html',
  styleUrls: ['./edit-festival.component.scss']
})
export class EditFestivalComponent implements OnInit {
  showLoader: boolean = false;
  date: string | undefined;


  festival: any;
  constructor(
    @Inject(MAT_DIALOG_DATA) public data: any,
    private dialogRef: MatDialogRef<EditFestivalComponent>,
    private utilityService: UtilityService,
    private festivalsService: FestivalsService,
    private snackbar: MatSnackBar,
  ) {
    this.dialogRef.disableClose = true;
  }

  ngOnInit(): void {
    if (this.data) {
      this.festival = this.data.event;
    }
    else {
      this.festival = {
        content: '',
        coverImage: '',
        title: '',
        date: ''
      }
    }
  }

  async sendImageEvent(e: any) {
    if (e.target.files.length > 0) {
      const imageWithBase64 = await this.utilityService.getBase64FromFile(e.target.files[0]);
      this.festival.coverImage = imageWithBase64;
    }
  }

  async saveFestival(ev: any) {
    // if (this.festival.date) {
      // this.festival.date = serverTimestamp()
    // }
    if (!this.festival.title || !this.festival.content || !this.festival.date) {
      if (!this.festival.title) {
        this.snackbar.open('Please enter title', 'OK', { duration: 3000 });
      } else if (!this.festival.content) {
        this.snackbar.open('Please enter content', 'OK', { duration: 3000 });
      } else if (!this.festival.date) {
        this.snackbar.open('Please select date', 'OK', { duration: 3000 });
      } 
    } else {
      this.showLoader = true;
      ev.target.disabled = true;
      const update = await this.festivalsService.updateFestivals(this.festival, this.festival.id);
      if (update) {
        this.snackbar.open('Festival Saved Successfully', 'OK', { duration: 3000 });
        this.dialogRef.close();
      }
      ev.target.disabled = false;
      this.showLoader = false;
    }
  }

  removeImage() {
    this.festival.coverImage = '';
  }

}
