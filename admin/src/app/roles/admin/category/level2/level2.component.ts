import { Component, OnInit } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { EditLevel2Component } from '../../dialogs/edit-level2/edit-level2.component';
import { CategoriesService } from 'src/app/services/categories.service';
import { Subscription } from 'rxjs';
import { SharedService } from 'src/app/services/shared.service';
import { MatCheckboxChange } from '@angular/material/checkbox';

@Component({
  selector: 'app-level2',
  templateUrl: './level2.component.html',
  styleUrls: ['./level2.component.scss']
})
export class Level2Component implements OnInit {
  showLoader: boolean = true;
  categories: any;
  categoryOneNames: any;
  AllCategOneNames: any;
  categOneData: any;
  level2Sub: Subscription | undefined;

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
    await this.getCategoryOne()
    this.showLoader = false;
    // console.log('aaaaaaa', (this.categories[0].coverImage))
    // await this.getCategoryOneNames()
  }

  async getCategory() {
    // console.log(this.categories)
    // this.categories = await this.categoriesService.getCategoryTwo();
    // console.log('category-L1', this.categories)

    const category = this.categoriesService.level2$.getValue();
    console.log(category)

    if (!category.length) {
      await this.categoriesService.getCategoryTwo();
    }

    this.level2Sub = this.categoriesService.level2$.subscribe(level2 => {
      this.categories = level2
    })

  }

  async getCategoryOne() {
    this.categOneData = await this.categoriesService.getCategoryOne();
    return this.categOneData
  }


  async addCategory() {
    const dialogRef = this.dialog.open(EditLevel2Component, {
      maxWidth: '80%',
      minWidth: 'fit-content'
    })

    dialogRef.afterClosed().subscribe(async result => {

    });

  }

  async editCategory(category: any) {
    const category2Clone = JSON.parse(JSON.stringify(category))
    const dialogRef = this.dialog.open(EditLevel2Component, {
      maxWidth: '80%',
      minWidth: 'fit-content',
      data: {
        category: category2Clone,
        // categOneData: this.categOneData
        // category
      }
    })

    dialogRef.afterClosed().subscribe(async result => {
      this.showLoader = true;
      await this.getCategory()
      this.showLoader = false;
      // return result.data

    });
  }

  deleteCategory(id: any) {
    this.sharedService.deleteSingleDoc(id, 'Categories-L2')
  }


  ngOnDestroy() {
    this.level2Sub?.unsubscribe();
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
    this.sharedService.openDeleteConfirmationModal('Categories-L2')
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

}
