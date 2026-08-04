import { Component, OnInit, Inject } from '@angular/core';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { MatSnackBar } from '@angular/material/snack-bar';
import { SubscriptionsService } from 'src/app/services/subscription.service';
import { Timestamp } from '@angular/fire/firestore';
@Component({
  selector: 'app-edit-subsription-types',
  templateUrl: './edit-subsription-types.component.html',
  styleUrls: ['./edit-subsription-types.component.scss']
})
export class EditSubsriptionTypesComponent {

  showLoader: boolean = false;
  subscription: any = {
    createdAt: Timestamp.now(),
    name: '',
    amount: ''
  };
  // date: string | undefined;

  constructor(
    @Inject(MAT_DIALOG_DATA) public data: any,
		public dialogRef: MatDialogRef<EditSubsriptionTypesComponent>,
    private subscriptionsService: SubscriptionsService,
    private snackbar: MatSnackBar,
  ) { 
    this.dialogRef.disableClose = true;
  }

  async ngOnInit() {
    console.log(this.data)
    if (this.data) {
      this.subscription =  this.data.subscription;
		}
  }

  async saveSubscription(e: any) {
    // this.subscription.date = this.subscription.date
    if (!this.subscription.name || !this.subscription.amount || this.subscription.amount == 0 ){
      if (!this.subscription.name ) {
        this.snackbar.open('Please enter Subscription Name', 'OK', { duration: 3000 });
      } else if(!this.subscription.amount){
        this.snackbar.open('Please enter amount', 'OK', { duration: 3000 });
      } else if( this.subscription.amount == 0 ){
        this.snackbar.open('Please enter amount more than 0', 'OK', { duration: 3000 });
      }
    }
    else{
      this.showLoader = true;
      e.target.disabled = true;
      const update = await this.subscriptionsService.updateSubscription(this.subscription, this.subscription.id);
      if (update) {
        this.snackbar.open('Subscription Saved Successfully', 'OK', { duration: 3000 });
        this.dialogRef.close();
      }
      e.target.disabled = false;
      this.showLoader = false;
    }
  }

  removeImage() {
    this.subscription.coverImage = '';
  }

}
