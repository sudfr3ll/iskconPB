import { Component, OnInit, Inject } from '@angular/core';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { MessagesService } from 'src/app/services/messages.service';
import { MatSnackBar } from '@angular/material/snack-bar';
import { UtilityService } from 'src/app/services/utility.service';
// import { NgxSpinnerService } from 'ngx-spinner';


@Component({
  selector: 'app-edit-message',
  templateUrl: './edit-message.component.html',
  styleUrls: ['./edit-message.component.scss']
})
export class EditMessageComponent implements OnInit {
  message: any;
  showLoader: boolean = false;

  constructor(
    @Inject(MAT_DIALOG_DATA) public data: any,
    public dialogRef: MatDialogRef<EditMessageComponent>,
    private messagesService: MessagesService,
    private utilityService: UtilityService,
    private snackbar: MatSnackBar,
    // private spinner: NgxSpinnerService
  ) {
    this.dialogRef.disableClose = true;
  }

  async ngOnInit() {
    if (this.data) {
      this.message = this.data.message; 
    }
    else {
      this.message = {
        author: '',
        coverImage: '',
        imgContent: '',
        messageContent: '',
        messageUrl: '',
        notifyUser: false
      };
    }
  }

  async saveMessage(event: any) { 

    if (!this.message.author || !this.message.imgContent || !this.message.messageContent ) {
      if (!this.message.author){
        this.snackbar.open('Please enter Author Name', 'OK', { duration: 3000});
      }  else if (!this.message.imgContent) {
        this.snackbar.open('Please enter Image Content', 'OK', { duration: 3000});
      } else if (!this.message.messageContent) {
        this.snackbar.open('Please enter Message Content', 'OK', { duration: 3000});
      } 
    } else {
      event.target.disabled = true;
      this.showLoader = true;
            const update = await this.messagesService.updateMessage(this.message, this.message.id);

      if (update) {
        this.snackbar.open('Message Saved Successfully', 'OK', { duration: 3000 });
        this.dialogRef.close();
      }
      this.showLoader = false;
      event.target.disabled = false;
    }

  }

  async sendImageEvent(e: any) {
    if (e.target.files.length > 0) {
      const imageWithBase64 = await this.utilityService.getBase64FromFile(e.target.files[0]);
      this.message.coverImage = imageWithBase64;
    }
  }

  close() {
    this.dialogRef.close();
  }

  removeImage() {
    this.message.coverImage = '';
  }

  onChange(enable: boolean) {
    const field = this.message.notifyUser;
    if (field == true) {
      field.enable;
      // console.log('check')
    } else {
      field.disable;
      // console.log('notcheck')
    }
    // this.updateText();
  }

}



