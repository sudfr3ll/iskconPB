import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { AuthService } from 'src/app/services/auth.service';

@Component({
  selector: 'app-sidemenu',
  templateUrl: './sidemenu.component.html',
  styleUrls: ['./sidemenu.component.scss']
})
export class SidemenuComponent implements OnInit {

  config = {
    paddingAtStart: true,
    classname: "side-nav-menu",
    fontColor: "#000",
    selectedListFontColor: "#7366ff",
    highlightOnSelect: true,
    useDividers: false,
    collapseOnSelect: true,
  };

  appitems = [
    {
      label: "Homepage Setting",
      icon: "settings",
      link: "/homepage-setting",
    },
    {
      label: "Live Darshan",
      icon: "live_tv",
      link: "/live-darshan",
    },
    {
      label: "Message",
      link: "/message",
      icon: "message"
    },
    {
      label: "Events",
      link: "/events",
      icon: "event_available"
    },
    {
      label: "Quotes",
      link: "/quotes",
      icon: "format_quote"
    },
    {
      label: "Pictures",
      link: "/pictures",
      icon: "insert_photo"
    },
    {
      label: "Audios",
      link: "/audios",
      icon: "audiotrack"
    },
    {
      label: "Videos",
      link: "/videos",
      icon: "ondemand_video"
    },
    {
      label: "Donations",
      // link: "/donation-types",
      icon: "attach_money",
      items: [
        {
          label: "Setting",
          link: "/donation-types",
          icon: "remove"
        },
        // {
        //   label: "User Donations",
        //   link: "",
        //   icon: "remove"
        // },

         {
          label: "Donations",
          link: "donations",
          icon: "remove"
        },
      ]
    },
     {
      label: "Subscriptions",
      // link: "/donation-types",
      icon: "attach_money",
      items: [
        {
          label: "Types",
          link: "/subscription-types",
          icon: "remove"
        },
        {
          label: "Subscriptions",
          link: "subscriptions",
          icon: "remove"
        },
      ]
    },
    {
      label: "Enquiries",
      link: "/enquiries",
      icon: "receipt"
    },
    {
      label:"Festivals",
      link : "/festivals",
      icon:"spa"
    },
    {
      label:"News",
      link : "/news",
      icon:"insert_comment"
    },
    {
      label: "Blogs",
      link: "/blogs",
      icon: "insert_comment"
    },
    {
      label: "Categories",
      icon: "menu",
      items: [
        {
          label: "Level-1",
          link: "/level-1",
          icon: "remove"
        },
        {
          label: "Level-2",
          link: "/level-2",
          icon: "remove"
        },
        {
          label:"Level-3",
          link:"/level-3",
          icon:"remove"
        }
      ]
    },
    {
      label: "Settings",
      icon: "settings",
      items: [
        {
          label: "Social Media",
          link: "/social-media",
          icon: "remove"
        },
        {
          label: "Contact Us",
          link: "/contact-us",
          icon: "remove"
        }
      ]
    },
    {
      label: "Logout",
      link: "/",
      icon: "logout",
      onSelected: () => {
        this.authService.logout();
      }
    }
  ];

  constructor(
    private router: Router,
    private authService: AuthService,
  ) { }

  ngOnInit(): void {
  }

  selectedItem(event:any) {
    // if (event.link == "/logout") {
    //   this.authService.logOut();
    //   return;
    // }

    this.router.navigate([event.link]);
  }

}
