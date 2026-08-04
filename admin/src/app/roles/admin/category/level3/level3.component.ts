import { Component, OnInit } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { EditLevel3Component } from '../../dialogs/edit-level3/edit-level3.component';
import { CategoriesService } from 'src/app/services/categories.service';
import { Subscription } from 'rxjs';
import { SharedService } from 'src/app/services/shared.service';
import { MatCheckboxChange } from '@angular/material/checkbox';

@Component({
  selector: 'app-level3',
  templateUrl: './level3.component.html',
  styleUrls: ['./level3.component.scss']
})
export class Level3Component implements OnInit {
  showLoader: boolean = true;
  categories: any;
  categoryOneNames: any;
  AllCategOneNames: any;
  categOneData: any;
  categoryTwoData: any;
  level3Sub: Subscription | undefined;
  check: boolean = false;
  showHeader: any = false;
  indeterminate = false;
  count: any;



  constructor(
    public dialog: MatDialog,
    private categoriesService: CategoriesService,
    public sharedService: SharedService

  ) { }

  async ngOnInit(): Promise<void> {
    await this.getCategory()
    this.showLoader = false;
    
    // await this.getCategoryOne()
    // await this.getCategoryTwo()
  }
 
  async getCategory() {
    // this.categories = await this.categoriesService.getCategoryThree();
    // console.log('category-L1', this.categories)

    const category = this.categoriesService.level3$.getValue();

    if (!category.length) {
     await  this.categoriesService.getCategoryThree();
    }

    this.level3Sub = this.categoriesService.level3$.subscribe(level3 => {
      this.categories = level3
    })


  }

  async addCategory() {
    const dialogRef = this.dialog.open(EditLevel3Component, {
      maxWidth: '80%',
      minWidth: 'fit-content'
    })

    dialogRef.afterClosed().subscribe(async result => {
      // console.log('result.data',result.data)
      // this.categories.push(result.data)

    });

  }

  async editCategory(category: any) {
    const category3Clone = JSON.parse(JSON.stringify(category))
    const dialogRef = this.dialog.open(EditLevel3Component, {
      maxWidth: '80%',
      minWidth: 'fit-content',
      data: {
        category: category3Clone,
        // categOneData: this.categOneData
        // category
      }
    })

    dialogRef.afterClosed().subscribe(async result => {
      // console.log('result.data',result.data)
        this.showLoader = true;
      await this.getCategory()
        this.showLoader = false;
      // this.categories = result.data
    });
  }

  deleteCategory(id: any) {
    this.sharedService.deleteSingleDoc(id, 'Categories-L3')

  }


  ngOnDestroy() {
    this.level3Sub?.unsubscribe();
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
    this.sharedService.openDeleteConfirmationModal('Categories-L3')
    this.showHeader = false;
    this.indeterminate = false
    // this.count = 0
    for (let item of this.categories) {
      item.checked = false;
    }
  }

  // async getCategoryOne() {
  //   this.categOneData = await this.categoriesService.getCategoryOne();
  //   console.log('category-L1', this.categOneData)
  //   return this.categOneData
  // }




  // async getCategoryTwo() {
  //   this.categoryTwoData = await this.categoriesService.getCategoryTwo();
  //   console.log('category-L1', this.categoryTwoData)
  //   return this.categoryTwoData
  // }

}
