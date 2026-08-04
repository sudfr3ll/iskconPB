import { updateDoc } from '@angular/fire/firestore';
import { ChangeDetectionStrategy, Component, HostListener, OnInit, Renderer2 } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { EditLevel1Component } from '../../dialogs/edit-level1/edit-level1.component';
import { CategoriesService } from 'src/app/services/categories.service';
import { CLIENT_RENEG_LIMIT } from 'tls';
import { Subscription } from 'rxjs';
import { SharedService } from 'src/app/services/shared.service';
import { MatCheckboxChange } from '@angular/material/checkbox';

@Component({
  selector: 'app-level1',
  templateUrl: './level1.component.html',
  styleUrls: ['./level1.component.scss'],
  // changeDetection: ChangeDetectionStrategy.OnPush
})
export class Level1Component implements OnInit {
 

  categories:any;
  level1Sub: Subscription | undefined;
  showLoader: boolean = true;
  listener: any;
  check: boolean = false;
  showHeader: any = false;
  indeterminate = false;
  count: any;

  constructor(
    public dialog: MatDialog,
    private categoryService : CategoriesService,
    public sharedService: SharedService,

  ) { 
  
  }

  async ngOnInit() {
    await this.getCateg()
    this.showLoader = false; 
  }

 

   async getCateg() {
    const category = this.categoryService.level1$.getValue();
    console.log(category)

    if (!category.length) {
      this.categories = await this.categoryService.getCategoryOne();
    }

    this.level1Sub = this.categoryService.level1$.subscribe(level1 => {
      console.log('level1', level1)
      this.categories = [...level1]
    })
  }

  async addCategory(){
    const dialogRef = this.dialog.open(EditLevel1Component, {
      maxWidth:'80%',
      minWidth: 'fit-content'
    })

    dialogRef.afterClosed().subscribe(async result => {

    });

  }

  async editCategory(category:any){
    const category1Clone = JSON.parse(JSON.stringify(category))
    const dialogRef = this.dialog.open(EditLevel1Component, {
      maxWidth:'80%',
      minWidth:'fit-content',
      data: {
        category: category1Clone
      }
    })

    dialogRef.afterClosed().subscribe(async result => {
      this.showLoader = true;
      await this.getCateg()
      this.showLoader = false;

    });
  }

  deleteCategory(id: any) {
    this.sharedService.deleteSingleDoc(id, 'Categories-L1')
  }


  ngOnDestroy() {
    this.level1Sub?.unsubscribe();
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
    this.sharedService.openDeleteConfirmationModal('Categories-L1')
    this.showHeader = false;
    this.indeterminate = false
    // this.count = 0
    for (let item of this.categories) {
      item.checked = false;
    }
  }
 
  getImage(data: any) {
    return this.sharedService.getImage(data)
  }
  getYPosition(e: Event): number {
    return (e.target as Element).scrollTop;
  }
  
}