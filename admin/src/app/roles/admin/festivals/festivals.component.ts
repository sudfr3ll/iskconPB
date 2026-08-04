import { Component, OnInit } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { Subscription } from 'rxjs';
import { FestivalsService } from 'src/app/services/festivals.service';
import { EditFestivalComponent } from '../dialogs/edit-festival/edit-festival.component';
import { SharedService } from 'src/app/services/shared.service';
import { MatCheckboxChange } from '@angular/material/checkbox';

@Component({
  selector: 'app-festivals',
  templateUrl: './festivals.component.html',
  styleUrls: ['./festivals.component.scss']
})
export class FestivalsComponent implements OnInit {
  
  festivals: any;
  festivalsSub: Subscription | undefined;
  showLoader: boolean = true;

  check: boolean = false;
  showHeader: any = false;
  indeterminate = false;
  count: any;

  constructor(
    private dialog : MatDialog,
    private festivalsService : FestivalsService,
    public sharedService: SharedService
  ) { }

  async ngOnInit(): Promise<void> {
    await this.getFestivals()
    this.showLoader = false;
  }

  async getFestivals(){
    const festivals = this.festivalsService.festivals$.getValue();

    if (!festivals.length) {
      await this.festivalsService.getFestivals();
    }

    this.festivalsSub = this.festivalsService.festivals$.subscribe(festival => {
      this.festivals = festival
    })

    
  }

  async addNewFestival(){
   
    this.dialog.open(EditFestivalComponent,{
      maxWidth: '80%',
      minWidth:'fit-content'
    })
  }

  async editFestival(event :any){
    const FestivalClone = JSON.parse(JSON.stringify(event))
    const dialogRef = this.dialog.open(EditFestivalComponent,{
    maxWidth : '80%',
    minWidth : 'fit-content',
    data : {
      event: FestivalClone
    }
   })

    dialogRef.afterClosed().subscribe(async result => {
      this.showLoader = true;
      await this.getFestivals()
      this.showLoader = false;
    });
  }

  deleteFestival(id: any) {
    this.sharedService.deleteSingleDoc(id, 'Festivals')
  }


  ngOnDestroy() {
    this.festivalsSub?.unsubscribe();
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
    this.sharedService.openDeleteConfirmationModal('Festivals')
    this.showHeader = false;
    this.indeterminate = false
    // this.count = 0
    for (let item of this.festivals) {
      item.checked = false;
    }
  }

}
