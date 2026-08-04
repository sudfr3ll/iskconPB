import { SharedService } from 'src/app/services/shared.service';
import { CategoriesService } from './../../../../services/categories.service';
import { Component, OnInit, Inject } from '@angular/core';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { UtilityService } from 'src/app/services/utility.service';
import { Level1Component } from '../../category/level1/level1.component';
import { MatSnackBar } from '@angular/material/snack-bar';
// import { SharedService } from 'src/app/services/shared.service';


@Component({
  selector: 'app-edit-level1',
  templateUrl: './edit-level1.component.html',
  styleUrls: ['./edit-level1.component.scss']
})
export class EditLevel1Component implements OnInit {
  showLoader: boolean = false;
  public slidValue: any;
  isChecked = true;
  types = [1, 2, 3, 4, 5];
  enable!: boolean;
  selectedItem: any;
  category: any;
  categoryTypes = ['audios', 'pictures', 'videos', 'blogs']
  constructor(
    public dialogRef: MatDialogRef<EditLevel1Component>,
    @Inject(MAT_DIALOG_DATA) public data: any,
    private categoriesService: CategoriesService,
    private utilityService: UtilityService,
    private snackbar: MatSnackBar,
    private sharedService: SharedService
  ) {
    this.dialogRef.disableClose = true;
  }

  ngOnInit(): void {
    this.categorydata()
  
  }

  categorydata() {
    if (this.data) {
      this.category = this.data.category;
    }
    else {
      this.category = {       
        // title: '',
        type: '',
        active: false,
        name: '',
        coverImage: '',
        // isSubCategory: false
      }
    }
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
    } else{
      this.showLoader = true;
      e.target.disabled = true;
      if(!this.category?.isSubCategory){
        this.category = { ...this.category, isSubCategory: false}
      }
      const update = await this.categoriesService.updateCategory1(this.category, this.category.id);
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
    // this.updateText();
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

  getImage(data: any) {
    return this.sharedService.getImage(data)
  }
}
