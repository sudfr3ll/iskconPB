import { CategoriesService } from './../../../../services/categories.service';
import { Component, OnInit, Inject } from '@angular/core';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { UtilityService } from 'src/app/services/utility.service';
import { Level1Component } from '../../category/level1/level1.component';
import { MatSnackBar } from '@angular/material/snack-bar';


@Component({
  selector: 'app-edit-level3',
  templateUrl: './edit-level3.component.html',
  styleUrls: ['./edit-level3.component.scss']
})
export class EditLevel3Component implements OnInit {
  showLoader: boolean = false;
  public slidValue: any;
  selectedCategory?: string;
  selectedCategoryName?: string;
  isChecked = true;
  types = [1, 2, 3, 4, 5];
  categoryId_l1: any;
  categoryId_l2: any;
  enable!: boolean;
  selectedItem: any;
  category: any;
  categoryOne: any;
  categoryOneId: any;
  categoryTwo: any;
  categoryTypes = ['audios', 'pictures', 'videos', 'blogs']

  constructor(
    public dialogRef: MatDialogRef<EditLevel3Component>,
    @Inject(MAT_DIALOG_DATA) public data: any,
    private categoriesService: CategoriesService,
    private utilityService: UtilityService,
    private snackbar: MatSnackBar,
  ) { this.dialogRef.disableClose = true; }

  ngOnInit(): void {
    if (this.data) {
      this.categoryId_l1 = this.data.category.categoryId_L1;
      this.categoryId_l2 = this.data.category.categoryId_L2;
    }
    this.categorydata()
    this.categoryOneNames()
    this.categoryTwoNames()

  }

  categorydata() {
    if (this.data) {
      this.category = this.data.category;
    }
    else {
      this.category = {
        coverImage: '',
        // title: '',
        type: '',
        active: false,
        name: '',
        categoryId_L1: '',
        categoryId_L2: ''
      }
    }
  }

  async categoryOneNames() {
    // if (!this.selectedCateg) return this.data.categOneData.type;
    const cat1data = await this.categoriesService.getCategoryOne();
    let arr = [];
    this.categoryOne = await cat1data.filter((obj: { type: any; }) => this.category.type == obj.type)
    for (let i = 0; i < this.categoryOne.length; i++) {
      arr.push(this.categoryOne[i].id)
      // this.categoryOneId = this.categoryOne[i].id;
    }

    this.categoryOneId = arr;
  }

  async categoryTwoNames() {
    // if (!this.selectedCateg) return this.data.categOneData.type;
    const categoryTwodata = await this.categoriesService.getCategoryTwo();

    this.categoryTwo = await categoryTwodata.filter((obj: {
      categoryId_L1: any; type: any;
    }) => this.categoryId_l1 == obj.categoryId_L1)

  }

  async saveCategory(e: any) {
    if (!this.category.coverImage || !this.category.name || !this.category.description || !this.category.type) {
      if (!this.category.coverImage) {
        this.snackbar.open('Please upload cover image', 'OK', { duration: 3000 });
      }
      else if (!this.category.name) {
        this.snackbar.open('Please enter name', 'OK', { duration: 3000 });
      } else if (!this.category.description) {
        this.snackbar.open('Please enter description', 'OK', { duration: 3000 });
      } else if (!this.category.type) {
        this.snackbar.open('Please choose category type', 'OK', { duration: 3000 });
      }
    } else {
      this.showLoader = true;
      e.target.disabled = true;
      this.category = { ...this.category, categoryId_L1: this.categoryId_l1, categoryId_L2: this.categoryId_l2 }
      this.dialogRef.close({ data: { ...this.category, categoryId_L1: this.categoryId_l1, categoryId_L2: this.categoryId_l2 } });

      const update = await this.categoriesService.updateCategory3(this.category, this.category.id);
      if (update) {
        this.snackbar.open('Category Updated Successfully', 'OK', { duration: 3000 });
        this.dialogRef.close({ data: this.category });

      }

      e.target.disabled = false;
      this.showLoader = false;
    }

  }

  onChange(enable: boolean) {
    const field = this.category.active;
    if (field == true) {
      field.enable;
    } else {
      field.disable;
    }
  }

  changetype(e: any) {
    this.categoryOneNames();
    this.categoryTwoNames()

  }

  async changeCategoryOneName(e: any) {

    this.categoryId_l1 = e.value
    const categoryTwodata = await this.categoriesService.getCategoryTwo();


    this.categoryTwo = await categoryTwodata.filter((obj: {
      categoryId_L1: any; type: any;
    }) => this.categoryId_l1 == obj.categoryId_L1)

  }

  async changeCategoryTwoName(e: any) {
    this.categoryId_l2 = e.value
  }

  async sendImageEvent(e: any) {
    if (e.target.files.length > 0) {
      const imageWithBase64 = await this.utilityService.getBase64FromFile(e.target.files[0]);
      this.category.coverImage = imageWithBase64;
    }
  }

  removeImage() {
    this.category.coverImage = '';
  }
}
