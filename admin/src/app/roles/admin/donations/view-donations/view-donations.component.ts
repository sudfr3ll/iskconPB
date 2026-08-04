import { Component, Inject, OnInit } from '@angular/core';
import { MatDialogRef ,MAT_DIALOG_DATA} from '@angular/material/dialog';

@Component({
  selector: 'app-view-donations',
  templateUrl: './view-donations.component.html',
  styleUrls: ['./view-donations.component.scss']
})
export class ViewDonationsComponent {

  donation: any;
  constructor(
    @Inject(MAT_DIALOG_DATA) public data: any,
    public dialogRef: MatDialogRef<ViewDonationsComponent>,
  ) {
    this.dialogRef.disableClose = true;
  }

  ngOnInit(): void {
    if (this.data) {
      this.donation = this.data.event;
      console.log('donation',this.donation);

    }
    else {
      this.donation = {
        // name: '',
        // email: '',
        // phone: ''
      }
    }
  }

  getName() {
    let name = '';
    switch (this.donation.payment.mode) {
      case 'CCAvenue':
        name = this.donation.payment.details.billing_name || '';
        break;
      case 'paytm':
        name = this.donation.userName || '';
        break;
    }
    return name;
  }
  getPhone() {
    let phoneNo = '';
    switch (this.donation.payment.mode) {
      case 'CCAvenue':
        phoneNo = this.donation.payment.details.billing_tel || '';
        break;
      case 'paytm':
        phoneNo = this.donation.phoneNo || '';
        break;
    }
    return phoneNo;
  }

  getCity() {
    let city = '';
    switch (this.donation.payment.mode) {
      case 'CCAvenue':
        city = this.donation.payment.details.billing_city;
        break;
      case 'paytm':
        city = '';
        break;
    }
    return city;
  }

  async closeDialog() {
    this.dialogRef.close();
  }

}
