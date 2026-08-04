import { Component } from '@angular/core';
import { Configuration, MultilevelNodes } from 'ng-material-multilevel-menu';
import { AuthService } from './services/auth.service';


@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.scss']
})
export class AppComponent {
  title = 'admin';
  isLoggedIn = false;

  constructor(private authService: AuthService) { }
  // showLoader: boolean = true;

  ngOnInit() {
    this.authService.isLoggedIn().subscribe(isLoggedIn => {
      this.isLoggedIn = isLoggedIn
    });
    this.authService.autoLogin();
  }
  

}
