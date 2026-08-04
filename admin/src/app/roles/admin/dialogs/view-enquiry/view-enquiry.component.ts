import { Component, Inject, OnInit } from '@angular/core';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';

@Component({
  selector: 'app-view-enquiry',
  templateUrl: './view-enquiry.component.html',
  styleUrls: ['./view-enquiry.component.scss']
})
export class ViewEnquiryComponent implements OnInit {
  enquiry: any;
  constructor(
    @Inject(MAT_DIALOG_DATA) public data: any,
    public dialogRef: MatDialogRef<ViewEnquiryComponent>,
  ) {
    this.dialogRef.disableClose = true;
  }

  ngOnInit(): void {
    if (this.data) {
      this.enquiry = this.data.event;
      // console.log('enquiry',this.enquiry);

    }
    else {
      this.enquiry = {
        name: '',
        email: '',
        phone: ''
      }
    }
  }

  async closeDialog() {
    this.dialogRef.close();
  }

}
