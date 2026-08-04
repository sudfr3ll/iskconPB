import { ComponentFixture, TestBed } from '@angular/core/testing';

import { EditLevel1Component } from './edit-level1.component';

describe('EditLevel1Component', () => {
  let component: EditLevel1Component;
  let fixture: ComponentFixture<EditLevel1Component>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ EditLevel1Component ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(EditLevel1Component);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
