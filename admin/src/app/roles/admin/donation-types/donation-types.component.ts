import { DonationsServiceService } from './../../../services/donations-service.service';
import { Component, OnInit } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { Subscription } from 'rxjs';
import { EditDonationTypesComponent } from '../dialogs/edit-donation-types/edit-donation-types.component';
import { SharedService } from 'src/app/services/shared.service';
import { MatCheckboxChange } from '@angular/material/checkbox';
import { MatSnackBar } from '@angular/material/snack-bar';

@Component({
  selector: 'app-donation-types',
  templateUrl: './donation-types.component.html',
  styleUrls: ['./donation-types.component.scss']
})
export class DonationTypesComponent implements OnInit {

  donationTypes: any;
  donationTypesSub: Subscription | undefined;
  showLoader: boolean = true;

  check: boolean = false;
  showHeader: any = false;
  indeterminate = false;
  count: any;

  constructor(
    private donationsServiceService: DonationsServiceService,
    public dialog: MatDialog,
    private snackbar: MatSnackBar,
    public sharedService: SharedService
  ) { 
    
  }

  async ngOnInit() {
    await this.getAllDonationTypes()
    this.showLoader = false;
  }

  async getAllDonationTypes() {


    const donationTypes = this.donationsServiceService.donationTypes$.getValue();

    if (!donationTypes.length) {
      await this.donationsServiceService.getDonationTypes();

    }

    this.donationTypesSub = this.donationsServiceService.donationTypes$.subscribe(donationTypes => {
      this.donationTypes = donationTypes;
    });
  }

  async editDonationType(donationType: any) {
    const cloneDonationTypes = JSON.parse(JSON.stringify(donationType))
    const dialogRef = this.dialog.open(EditDonationTypesComponent, {
      maxWidth: '80%',
      minWidth: 'fit-content',
      data: {
        donationType: cloneDonationTypes,
      }
    });

    dialogRef.afterClosed().subscribe(async result => {
      // console.log('result.data',result.data)
      this.showLoader = true;
      await this.getAllDonationTypes()
      this.snackbar.open('Saved Successfully', 'OK', { duration: 3000 });
      this.showLoader = false;
    });
  }

  async addNewDonationType() {
    this.dialog.open(EditDonationTypesComponent, {
      maxWidth: '80%',
      minWidth: 'fit-content'
    });


  }

  deleteDonationType(id: any) {
    this.sharedService.deleteSingleDoc(id, 'DonationTypes')

  }


  ngOnDestroy() {
    this.donationTypesSub?.unsubscribe();
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
    this.sharedService.openDeleteConfirmationModal('DonationTypes')
    this.showHeader = false;
    this.indeterminate = false
    // this.count = 0
    for (let item of this.donationTypes) {
      item.checked = false;
    }
  }

  getImage(data: any) {
    return this.sharedService.getImage(data)
  }
}


