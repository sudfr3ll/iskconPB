import { Component, OnInit } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { Subscription } from 'rxjs';
import { BlogsService } from 'src/app/services/blogs.service';
import { EditBlogsComponent } from '../dialogs/edit-blogs/edit-blogs.component';
import { SharedService } from 'src/app/services/shared.service';
import { MatSnackBar } from '@angular/material/snack-bar';
import { MatCheckboxChange } from '@angular/material/checkbox';

@Component({
  selector: 'app-blogs',
  templateUrl: './blogs.component.html',
  styleUrls: ['./blogs.component.scss']
})
export class BlogsComponent implements OnInit {

  blogs: any;
  blogsSub: Subscription | undefined;
  showLoader: boolean = true;

  check: boolean = false;
  showHeader: any = false;
  indeterminate = false;
  count: any;


  constructor(
    private dialog: MatDialog,
    private blogsService: BlogsService,
    private snackbar: MatSnackBar,
    public sharedService: SharedService
  ) { }

  async ngOnInit(): Promise<void> {
    await this.getBlogs()
    this.showLoader = false;
  }

  async getBlogs() {
    const blogs = this.blogsService.blogs$.getValue();

    if (!blogs.length) {
      await this.blogsService.getBlogs();
    }

    this.blogsSub = this.blogsService.blogs$.subscribe(blog => {
      this.blogs = blog
    })


  }

  async addNewBlog() {

    this.dialog.open(EditBlogsComponent, {
      maxWidth: '80%',
      minWidth: 'fit-content'
    })
  }

  async editBlog(event: any) {
    const BlogClone = JSON.parse(JSON.stringify(event))
    const dialogRef = this.dialog.open(EditBlogsComponent, {
      maxWidth: '80%',
      minWidth: 'fit-content',
      data: {
        event: BlogClone
      }
    })

    dialogRef.afterClosed().subscribe(async result => {
      this.showLoader = true;

      await this.getBlogs()
      this.snackbar.open('Blog Saved Successfully', 'OK', { duration: 3000 });
      this.showLoader = false;
    });
  }

  deleteBlog(id: any) {
    this.sharedService.deleteSingleDoc(id, 'Blogs')
  }


  ngOnDestroy() {
    this.blogsSub?.unsubscribe();
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
    this.sharedService.openDeleteConfirmationModal('Blogs')
    this.showHeader = false;
    this.indeterminate = false
    // this.count = 0
    for (let item of this.blogs) {
      item.checked = false;
    }
  }

  getImage(data: any) {
    return this.sharedService.getImage(data)
  }
}
