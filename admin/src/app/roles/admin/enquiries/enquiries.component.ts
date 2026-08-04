import { Component, OnInit } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { ViewEnquiryComponent } from '../dialogs/view-enquiry/view-enquiry.component';
import { EnquiriesService } from 'src/app/services/enquiries.service';
import { SharedService } from 'src/app/services/shared.service';
import { MatCheckboxChange } from '@angular/material/checkbox';

@Component({
  selector: 'app-enquiries',
  templateUrl: './enquiries.component.html',
  styleUrls: ['./enquiries.component.scss']
})
export class EnquiriesComponent implements OnInit {
  check: boolean = false;
  showHeader: any = false;
  indeterminate = false;
  count: any;
  enquiries :any;
  constructor(
    private dialog : MatDialog,
    private enquiriesService : EnquiriesService,
    public sharedService: SharedService

  ) { }

  async ngOnInit(): Promise<void> {
    if(!this.enquiries){
      this.enquiries = await this.enquiriesService.getEnquiry();
      
    }
  }
  async viewEnquiry(event:any){
    this.dialog.open(ViewEnquiryComponent,{
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
    for (let item of this.enquiries) {
      item.checked = false;
    }
  }

}
