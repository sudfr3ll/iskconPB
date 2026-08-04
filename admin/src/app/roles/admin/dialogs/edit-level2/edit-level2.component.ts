import { CategoriesService } from './../../../../services/categories.service';
import { Component, OnInit, Inject } from '@angular/core';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { UtilityService } from 'src/app/services/utility.service';
import { Level1Component } from '../../category/level1/level1.component';
import { MatSnackBar } from '@angular/material/snack-bar';


@Component({
  selector: 'app-edit-level2',
  templateUrl: './edit-level2.component.html',
  styleUrls: ['./edit-level2.component.scss']
})
export class EditLevel2Component implements OnInit {
  showLoader: boolean = false;
  public slidValue: any;
  selectedCategory?: string;
  selectedCategoryName?: string;
  isChecked = true;
  types = [1, 2, 3, 4, 5];
  categoryId_l1: any;
  enable!: boolean;
  selectedItem: any;
  category: any;
  categoryOne: any;
  categoryTypes = ['audios', 'pictures', 'videos', 'blogs']

  constructor(
    public dialogRef: MatDialogRef<EditLevel2Component>,
    @Inject(MAT_DIALOG_DATA) public data: any,
    private categoriesService: CategoriesService,
    private utilityService: UtilityService,
    private snackbar: MatSnackBar,
  ) { this.dialogRef.disableClose = true; }

  async ngOnInit() {
    if (this.data) {
      this.categoryId_l1 = this.data?.category.categoryId_L1;
    }
    this.categorydata()
    this.categoryOneNames()

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
        categoryId_L1: ''
      }
      // console.log(this.category)
    }
  }

  async categoryOneNames() {
    // if (!this.selectedCateg) return this.data.categOneData.type;
    const cat1data = await this.categoriesService.getCategoryOne();
    this.categoryOne = await cat1data.filter((obj: { type: any; }) => this.category.type == obj.type)

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
      // console.log('aaaaaaaaa', this.categoryId_l1);

      this.category = { ...this.category, categoryId_L1: this.categoryId_l1 }

      this.dialogRef.close({ data: { ...this.category, categoryId_L1: this.categoryId_l1 } });

      const update = await this.categoriesService.updateCategory2(this.category, this.category.id);
      if (update) {
        this.snackbar.open('Category Updated Successfully', 'OK', { duration: 3000 });
        this.dialogRef.close({ data: { ...this.category, categoryId_L1: this.categoryId_l1 } });

        // this.category.categoryId_L1 ="selectedCategoryName";
      }

      e.target.disabled = false;
      this.showLoader = false;
    }

  }

  onChange(enable: boolean) {
    const field = this.category.active;
    if (field == true) {
      field.enable;
      // console.log('check')
    } else {
      field.disable;
      // console.log('notcheck')
    }
    // this.updateText();
  }

  changetype(e: any) {
    // console.log(e.target)
    this.categoryOneNames();
  }



  async changeCategName(e: any) {
    // console.log(e.value)
    this.categoryId_l1 = e.value
    // console.log('mkjbhygf', this.categoryId_l1)
  }

  async sendImageEvent(e: any) {
    // console.log(e.target.files)
    if (e.target.files.length > 0) {
      const imageWithBase64 = await this.utilityService.getBase64FromFile(e.target.files[0]);
      // console.log('imageWithBase64',imageWithBase64)
      this.category.coverImage = imageWithBase64;
    }
  }
  removeImage() {
    this.category.coverImage = '';
  }
}
