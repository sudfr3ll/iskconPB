import { Component, OnInit } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { ViewDonationsComponent } from './view-donations/view-donations.component';
import { DonationsServiceService } from 'src/app/services/donations-service.service';
import { SharedService } from 'src/app/services/shared.service';
import { MatCheckboxChange } from '@angular/material/checkbox';
import { DatePipe } from '@angular/common';
import { subDays } from 'date-fns';
import { MatSnackBar } from '@angular/material/snack-bar';

@Component({
  selector: 'app-donations',
  templateUrl: './donations.component.html',
  styleUrls: ['./donations.component.scss']
})
export class DonationsComponent {
  startDate: any;
  endDate: any
  check: boolean = false;
  showHeader: any = false;
  indeterminate = false;
  count: any;
  searchTerm: string = '';
  donations: any;
  constructor(
    private dialog: MatDialog,
    private donationsService: DonationsServiceService,
    public sharedService: SharedService,
    private datePipe: DatePipe,
    private snackbar: MatSnackBar,

  ) { }

  async ngOnInit(): Promise<void> {
    const currentDate = new Date();
    const startDate = subDays(currentDate, 30);

    if (!this.donations) {
      this.donations = await this.donationsService.getDonations(startDate, currentDate);
    }

    console.log('this.donations', this.donations);

  }
  async viewDonation(event: any) {
    this.dialog.open(ViewDonationsComponent, {
      maxWidth: '80%',
      minWidth: 'fit-content',
      data: {
        event
      }
    })
  }

  search(startDate: Date, endDate: Date) {
    this.donationsService.getDonations(startDate, endDate)
      .then(donations => {
        this.donations = donations;
      });

    if (!this.donations.length) {
      this.snackbar.open('No dnations are received during this time interval.', 'OK', { duration: 3000 });
    }
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
    this.sharedService.openDeleteConfirmationModal('donations')
    this.showHeader = false;
    this.indeterminate = false
    // this.count = 0
    for (let item of this.donations) {
      item.checked = false;
    }
  }

  formatDate(date: any) {
    const milliseconds = date.seconds * 1000 + date.nanoseconds / 1000000;
    const formattedDate = new Date(milliseconds);
    return this.datePipe.transform(formattedDate, 'yyyy-MM-dd HH:mm:ss');
  }

  convertToDate(dateString: string): Date {
    return new Date(dateString);
  }

}
