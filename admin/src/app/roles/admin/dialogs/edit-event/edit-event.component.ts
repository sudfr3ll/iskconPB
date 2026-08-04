import { Component, OnInit, Inject } from '@angular/core';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { MatSnackBar } from '@angular/material/snack-bar';
import { EventsService } from 'src/app/services/events.service';
import { UtilityService } from 'src/app/services/utility.service';

@Component({
  selector: 'app-edit-event',
  templateUrl: './edit-event.component.html',
  styleUrls: ['./edit-event.component.scss']
})
export class EditEventComponent implements OnInit {
  event: any;
  date: string | undefined;
  showLoader: boolean = false;
  keyword: string = '';

  constructor(
    @Inject(MAT_DIALOG_DATA) public data: any,
		public dialogRef: MatDialogRef<EditEventComponent>,
    private eventsService: EventsService,
    private utilityService: UtilityService,
    private snackbar: MatSnackBar,
  ) { 
    this.dialogRef.disableClose = true;
  }

  async ngOnInit() {

    if (this.data) {
      this.event =  this.data.event;
      this.event['keywords'] = "keywords" in this.event ? this.event.keywords : [];
		}
    else {
      this.event = {
        content: '',
        coverImage: '',
        title: '',
        eventLink: ' ',
        donationAllowed: false,
        date: '',
        keywords: [],
        description: ''
        // donationAllowed: false,
        // date: ''
      }
    }
  }

  async saveEvent(e: any) {

    if (!this.event.title || !this.event.coverImage || !this.event.date || !this.event.content) {
      if (!this.event.title) {
        this.snackbar.open('Please enter Author Name', 'OK', { duration: 3000 });
      }
      else if (!this.event.coverImage) {
        this.snackbar.open('Please upload cover image', 'OK', { duration: 3000 });
      } else if (!this.event.content) {
        this.snackbar.open('Please enter Content', 'OK', { duration: 3000 });
      } else if (!this.event.date) {
        this.snackbar.open('Please choose date', 'OK', { duration: 3000 });
      } 
    }else{
      e.target.disabled = true;
      this.showLoader = true;
      const update = await this.eventsService.updateEvent(this.event, this.event.id);
      this.showLoader = false;
      if (update) {
        this.snackbar.open('Event Saved Successfully', 'OK', { duration: 3000 });
        this.dialogRef.close();
      }
      e.target.disabled = false;
    }

 
  }

  async sendImageEvent(e: any) {
    if(e.target.files.length>0) {
      const imageWithBase64 = await this.utilityService.getBase64FromFile(e.target.files[0]);
      this.event.coverImage = imageWithBase64;
    }
  }

  removeImage() {
    this.event.coverImage = '';
  }

  onChangeDonationAllowed(enable: boolean) {
    const field = this.event.donationAllowed;
    if (field == true) {
      field.enable;
    } else {
      field.disable;
    }
  }

  addKeyword() {
    const value = (this.keyword || '').trim().toLowerCase();
    console.log("value", value);
    if (value) {
      const index = this.event.keywords.indexOf(value);
      if (index > -1) {
        this.snackbar.open('Already added', 'OK', { duration: 3000 });
      } else {
        this.event.keywords.push(value);
      }
    }
    this.keyword = '';
    console.log("keywords", this.event.keywords);
  }

  removeKeyword(keyword: string) {
    const index = this.event.keywords.indexOf(keyword);
    if (index > -1) {
      this.event.keywords.splice(index, 1);
    }
  }

}
