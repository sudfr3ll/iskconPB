import { Component, OnInit } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { ViewSubscriptionsComponent } from './view-subscriptions/view-subscriptions.component';
import { SubscriptionsService } from 'src/app/services/subscription.service';
import { SharedService } from 'src/app/services/shared.service';
import { MatCheckboxChange } from '@angular/material/checkbox';
import { DatePipe } from '@angular/common';

@Component({
  selector: 'app-subscriptions',
  templateUrl: './subscriptions.component.html',
  styleUrls: ['./subscriptions.component.scss']
})
export class SubscriptionsComponent {

  check: boolean = false;
  showHeader: any = false;
  indeterminate = false;
  count: any;
  subscriptions :any;
  constructor(
    private dialog : MatDialog,
    private subscriptionsService : SubscriptionsService,
    public sharedService: SharedService,
    private datePipe: DatePipe

  ) { }

  async ngOnInit(): Promise<void> {
    if(!this.subscriptions){
      this.subscriptions = await this.subscriptionsService.getAllSubscriptions();
      
    }
    console.log('this.subscriptions', this.subscriptions)
  }
  async viewSubscription(event:any){
    this.dialog.open(ViewSubscriptionsComponent,{
      maxWidth: '80%',
      minWidth:'fit-content',
      data: {
        event
      }
    })
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
    this.sharedService.openDeleteConfirmationModal('Enquiries')
    this.showHeader = false;
    this.indeterminate = false
    // this.count = 0
    for (let item of this.subscriptions) {
      item.checked = false;
    }
  }

  formatDate(date: any) {
    const milliseconds = date.seconds * 1000 + date.nanoseconds / 1000000;
    const formattedDate = new Date(milliseconds);
    return this.datePipe.transform(formattedDate, 'yyyy-MM-dd HH:mm:ss');
  }

}
  