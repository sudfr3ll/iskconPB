import { Component, OnInit } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { Subscription } from 'rxjs';
import { SubscriptionsService } from 'src/app/services/subscription.service';
import { EditSubsriptionTypesComponent } from './edit-subsription-types/edit-subsription-types.component';
import { SharedService } from 'src/app/services/shared.service';
import { MatCheckboxChange } from '@angular/material/checkbox';

@Component({
  selector: 'app-subscription-types',
  templateUrl: './subscription-types.component.html',
  styleUrls: ['./subscription-types.component.scss']
})
export class SubscriptionTypesComponent {

  subscriptions: any;
  subscriptionsSub: Subscription | undefined;

  check: boolean = false;
  showHeader: any = false;
  indeterminate = false;
  count: any;

  constructor(
    private subscriptionsService: SubscriptionsService,
    public dialog: MatDialog,
    private sharedService: SharedService
  ) { }

  async ngOnInit() {
  this.getAllSubscriptions()
  }

  async getAllSubscriptions(){
    if (!this.subscriptions) {
      this.subscriptions = await this.subscriptionsService.getSubscriptions();
    }

    this.subscriptions = await this.subscriptionsService.getSubscriptions();

    const subscriptions = this.subscriptionsService.subscriptions$.getValue();

    if (!subscriptions.length) {
      this.subscriptionsService.getSubscriptions();
    }

    this.subscriptionsSub = this.subscriptionsService.subscriptions$.subscribe(subscription => {
      this.subscriptions = subscription
    })
  }

  async editSubscription(subscription: any) {

    const cloneSubscription = JSON.parse(JSON.stringify(subscription))
    const dialogRef = this.dialog.open(EditSubsriptionTypesComponent, {
      maxWidth: '80%',
      minWidth: 'fit-content',
      data: {
        subscription: cloneSubscription
      }
    });

    dialogRef.afterClosed().subscribe(async result => {
      console.log('result.data',result)
      await this.getAllSubscriptions()
    });
  }

  async addNewSubscription() {
    this.dialog.open(EditSubsriptionTypesComponent, {
      maxWidth: '80%',
      minWidth: '50%'
    });
  }

  deleteSubscription(id: any) {
    this.sharedService.deleteSingleDoc(id, 'subscriptionTypes')
  }


  ngOnDestroy() {
    this.subscriptionsSub?.unsubscribe();
  }

  onSelectCheckBox(ob: MatCheckboxChange, item: any, data: any) {
    const obj = this.sharedService.onSelectCheckBox(ob, item, data)
    this.showHeader = obj.showHead;
    this.indeterminate = obj.indeterminate
    this.count = obj.count
  }

  onClickSelectAllCheckBox(ob: MatCheckboxChange, data: any) {

    const obj = this.sharedService.onClickSelectAllCheckBox(ob, data)
    this.count = obj.count
    this.showHeader = obj.showHead;
    this.indeterminate = obj.indeterminate
    this.count = obj.count
  }

  onClickCross(data: any) {
    const obj = this.sharedService.onClickCross(data)
    this.showHeader = obj.showHead;
    this.indeterminate = obj.indeterminate
    this.count = obj.count
  }

  openDeleteConfirmationModal(): void {
    this.sharedService.openDeleteConfirmationModal('subscriptionTypes')
    this.showHeader = false;
    this.indeterminate = false
    // this.count = 0
    for (let item of this.subscriptions) {
      item.checked = false;
    }
  }

}

