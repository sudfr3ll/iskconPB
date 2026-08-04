import { Component, OnInit } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { EditPicturesComponent } from '../dialogs/edit-pictures/edit-pictures.component';
import { PicturesService } from 'src/app/services/pictures.service';
import { Subscription } from 'rxjs';
import { SharedService } from 'src/app/services/shared.service';
import { MatCheckboxChange } from '@angular/material/checkbox';

@Component({
  selector: 'app-pictures',
  templateUrl: './pictures.component.html',
  styleUrls: ['./pictures.component.scss']
})
export class PicturesComponent implements OnInit {

  pictures:any;
  picturesSub: Subscription | undefined;
  showLoader: boolean = true;

  check: boolean = false;
  showHeader: any = false;
  indeterminate = false;
  count: any;

  constructor(
    public dialog: MatDialog,
    private pictureService : PicturesService,
    private sharedService: SharedService
  ) { }

  async ngOnInit(): Promise<void> {
    await this.getPictures()
    this.showLoader = false;
  }

  async onScroll() {
    console.log('scrolled')
    this.showLoader = true;

    const messasges = this.pictureService.pictures$.getValue();
    console.log(messasges)

    if (messasges.length) {
      await this.pictureService.getMorePictures();
      // console.log(await this.pictureService.getMorePictures())
      const obj: any = await this.pictureService.getMorePictures()
      console.log('objjjjjjjjjjjjjjjjjj', obj)
      if (obj.status == 'available') {
        this.pictures = obj.data
        console.log('available')
      } 
      this.showLoader = false;
    }
    this.showLoader = false;
  }

  async getPictures(){
    this.showLoader = true;

    const messasges = this.pictureService.pictures$.getValue();

    if (!messasges.length) {
      await this.pictureService.getPicture();
      
      // this.showLoader = false;
    }

    this.picturesSub = this.pictureService.pictures$.subscribe(msg => {
      this.pictures = msg
    });
    this.showLoader = false;

  }



  async addPictures() {
    const dialogRef = this.dialog.open(EditPicturesComponent, {
      maxWidth: '80%',
      minWidth: 'fit-content',
     
    })

    dialogRef.afterClosed().subscribe(async result => {
      this.showLoader = true;
      if (result === 'success') {
        this.picturesSub = this.pictureService.pictures$.subscribe(msg => {
      this.pictures = msg
    })}
      this.showLoader = false;
    });

  }

  async editPictures(picture: any) {
    const cpictureClone = JSON.parse(JSON.stringify(picture))
    const dialogRef = this.dialog.open(EditPicturesComponent, {
      maxWidth: '80%',
      minWidth: 'fit-content',
      data: {
        
        picture: cpictureClone,
        // categOneData: this.categOneData
        // category
      }
    })

    dialogRef.afterClosed().subscribe(async result => {
      // console.log('result.data',result.data)
      this.showLoader = true;
      await this.getPictures()
      this.showLoader = false;
    });
  }

  deletePicture(id: any) {
    this.sharedService.deleteSingleDoc(id, 'Pictures')
    // return this.pictureService.delete(id)
  }


  ngOnDestroy() {
    this.picturesSub?.unsubscribe();
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
    this.sharedService.openDeleteConfirmationModal('Pictures')
    this.showHeader = false;
    this.indeterminate = false
    // this.count = 0
    for (let item of this.pictures) {
      item.checked = false;
    }
  }

}
