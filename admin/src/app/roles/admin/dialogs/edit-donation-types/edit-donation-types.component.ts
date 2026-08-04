import { Component, OnInit, Inject } from '@angular/core';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { MatSnackBar } from '@angular/material/snack-bar';
import { DonationsServiceService } from 'src/app/services/donations-service.service';
import { UtilityService } from 'src/app/services/utility.service';

@Component({
  selector: 'app-edit-donation-types',
  templateUrl: './edit-donation-types.component.html',
  styleUrls: ['./edit-donation-types.component.scss']
})
export class EditDonationTypesComponent implements OnInit {
  donationType: any;
  showLoader: boolean = false;

  constructor(
    @Inject(MAT_DIALOG_DATA) public data: any,
    public dialogRef: MatDialogRef<EditDonationTypesComponent>,
    private donationsServiceService: DonationsServiceService,
    private utilityService: UtilityService,
    private snackbar: MatSnackBar,
  ) {
    this.dialogRef.disableClose = true;
}

  ngOnInit(): void {
    if (this.data) {
      this.donationType = this.data.donationType;
    }
    else {
      this.donationType = {
        content: '',
        coverImage: '',
        name: '',
        minAmount:'',
        maxAmount:''
      }
    }
  }

  async saveDonationType(e: any) {

    if (!this.donationType.name || !this.donationType.coverImage || !this.donationType.content || !this.donationType.minAmount || !this.donationType.maxAmount || this.donationType.maxAmount < 0 || this.donationType.minAmount < 0 || this.donationType.maxAmount < this.donationType.minAmount) {
      if (!this.donationType.name) {
        this.snackbar.open('Please enter Name', 'OK', { duration: 3000 });
      }
      else if (!this.donationType.coverImage) {
        this.snackbar.open('Please upload cover image', 'OK', { duration: 3000 });
      } else if (!this.donationType.content) {
        this.snackbar.open('Please enter Content', 'OK', { duration: 3000 });
      } else if (!this.donationType.maxAmount) {
        this.snackbar.open('Please enter maximum amount', 'OK', { duration: 3000 });
      } else if (!this.donationType.minAmount) {
        this.snackbar.open('Please enter minimum amount', 'OK', { duration: 3000 });
      } else if (this.donationType.minAmount < 0) {
        this.snackbar.open('Minimum amount should be more than 0', 'OK', { duration: 3000 });
      } else if (this.donationType.maxAmount < 0) {
        this.snackbar.open('Maximum amount should be more than 0', 'OK', { duration: 3000 });
      } else if (this.donationType.maxAmount < this.donationType.minAmount) {
        this.snackbar.open('Maximum amount should be more than Minimum Amount', 'OK', { duration: 3000 });
      }
    } else {
      e.target.disabled = true;
      this.showLoader = true;
      const update = await this.donationsServiceService.updateDonationTypes(this.donationType, this.donationType.id);
      this.showLoader = false;
      if (update) {
        this.dialogRef.close();
      }
      e.target.disabled = false;
    }


  }

  async sendImageDonationType(e: any) {
    if (e.target.files.length > 0) {
      const imageWithBase64 = await this.utilityService.getBase64FromFile(e.target.files[0]);
      this.donationType.coverImage = imageWithBase64;
    }
  }

  removeImage() {
    this.donationType.coverImage = '';
  }

}

