import { Component, Inject, OnInit } from '@angular/core';
import { MatDialogRef ,MAT_DIALOG_DATA} from '@angular/material/dialog';

@Component({
  selector: 'app-view-subscriptions',
  templateUrl: './view-subscriptions.component.html',
  styleUrls: ['./view-subscriptions.component.scss']
})
export class ViewSubscriptionsComponent {

  subscription: any;
  constructor(
    @Inject(MAT_DIALOG_DATA) public data: any,
    public dialogRef: MatDialogRef<ViewSubscriptionsComponent>,
  ) {
    this.dialogRef.disableClose = true;
  }

  ngOnInit(): void {
    if (this.data) {
      this.subscription = this.data.event;
      // console.log('subscription',this.subscription);

    }
    else {
      this.subscription = {
        name: '',
        magazineName: '',
        user: {}
      }
    }
  }

  async closeDialog() {
    this.dialogRef.close();
  }

}
